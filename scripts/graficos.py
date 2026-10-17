import boto3
import pandas as pd
import json
import io
import matplotlib.pyplot as plt
import seaborn as sns
import os

# Configuração visual
sns.set_theme(style="whitegrid")
os.makedirs("docs", exist_ok=True)

s3 = boto3.client('s3')

def descobrir_bucket():
    buckets = s3.list_buckets()['Buckets']
    for b in buckets:
        if 'datamart-qualidade-datalake' in b['Name']:
            return b['Name']
    raise Exception("Bucket não encontrado")

def processar():
    bucket = descobrir_bucket()
    response = s3.list_objects_v2(Bucket=bucket, Prefix='refined/')
    if 'Contents' not in response:
        print("Nenhum arquivo em refined.")
        return

    dfs = []
    for obj in response['Contents']:
        if obj['Key'].endswith('.parquet') and obj['Size'] > 0:
            data = s3.get_object(Bucket=bucket, Key=obj['Key'])
            buffer = io.BytesIO(data['Body'].read())
            dfs.append(pd.read_parquet(buffer))
    
    if not dfs:
        return
        
    df = pd.concat(dfs, ignore_index=True)
    
    # 1. Gráfico: Faturamento por Região
    plt.figure(figsize=(10, 5))
    sns.barplot(data=df, x='regiao', y='valor_total', estimator=sum, errorbar=None, palette="viridis")
    plt.title('Faturamento Total por Região')
    plt.ylabel('Faturamento (R$)')
    plt.xlabel('Região')
    plt.tight_layout()
    plt.savefig('docs/grafico_regiao.png')
    plt.close()

    # 2. Gráfico: Top Produtos
    plt.figure(figsize=(10, 5))
    sns.barplot(data=df, y='produto', x='valor_total', estimator=sum, errorbar=None, palette="magma", order=df.groupby('produto')['valor_total'].sum().sort_values(ascending=False).index)
    plt.title('Top Produtos por Faturamento')
    plt.xlabel('Faturamento (R$)')
    plt.ylabel('Produto')
    plt.tight_layout()
    plt.savefig('docs/grafico_produtos.png')
    plt.close()

    # 3. Gráfico: Vendas por Canal (Pizza)
    plt.figure(figsize=(8, 8))
    df.groupby('canal_venda')['valor_total'].sum().plot.pie(autopct='%1.1f%%', startangle=90, cmap="Set3")
    plt.title('Distribuição de Faturamento por Canal')
    plt.ylabel('')
    plt.tight_layout()
    plt.savefig('docs/grafico_canal.png')
    plt.close()

    print("✅ Gráficos salvos na pasta 'docs/' com sucesso!")

if __name__ == "__main__":
    processar()