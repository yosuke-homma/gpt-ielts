FROM node:20.10.0-alpine  
WORKDIR /usr/src/app

# 依存関係ファイルをコピー
COPY app/package.json app/package-lock.json* ./

# 依存関係をインストール
RUN npm install

# アプリケーションのソースコードをコピー
COPY app/ .
