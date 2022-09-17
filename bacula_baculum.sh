Processo de instalação do Bacula e baculum 

Faça o cadastro no site: https://www.bacula.org/bacula-binary-package-download/
Com o repositório enviado por e-mail, de inicio ao processo de instalação.

Script Instalação Automática Debian e CentOS
1) Efetuar o download do script de instalação, dar permissão e executar
wget -c https://raw.githubusercontent.com/wanderleihuttel/bacula-utils/master/conf/scripts/_bacula_community_package.sh -O /usr/local/bin/_bacula_community_install.sh
chmod a+x /usr/local/bin/_bacula_community_install.sh
/usr/local/bin/_bacula_community_install.sh
2) Informar a chave do Bacula recebida por email
--------------------------------------------------
# Informe sua chave do Bacula 
# Esta chave é obtida com o registro em Bacula.org
# https://www.bacula.org/bacula-binary-package-download/
Please, fill with your Bacula Key:

Os pacotes ainda estão demorando um pouco para sair após a liberação das versões com código fonte, então não espere a última versão do pacote assim que sair uma nova versão do Bacula.
Provavelmente num futuro próximo a equipe do Bacula Community pode ir melhorando isso.

Por enquanto é preciso preencher a versão para debian ou centos que é a última disponível para cada sistema operacional.
Este script foi testado em CentOS 7.5 e Debian 9.5 (stretch)
3) Informar a versão para instalação.
# Este script só funcionará com as versões mais recentes do Debian e do CentOS
--------------------------------------------------
Inform the Bacula version
  - 9.0.0
  - 9.0.4
  - 9.0.5
  - 9.0.6
  - 9.0.7
  - 9.0.8
  - 9.2.0
  - 9.2.1
  - 9.2.2
Choose your Bacula Version:
4) Selecionar o banco de dados MySQL ou PostgreSQL
What do you want to do?
  1) Install Bacula with PostgreSQL
  2) Install Bacula with MySQL
  3) Exit
Select an option [1-3]:

*Observações: este script é indicado para máquinas com o sistema operacional limpo, sem nenhum banco de dados ou o Bacula instalado.
Instalação Manual Debian
#!/bin/bash
bacula_version="11.0.5"
bacula_key="XXXXXXXXXXXXX"
linux_name="buster"
export DEBIAN_FRONTEND=noninteractive
# Requisitos para instalar o Bacula por pacotes
apt-get install -y zip wget bzip2 apt-transport-https gnupg2
# Download da chaves do repositório
wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc
# Adicionar chave no repositório local
apt-key add /tmp/Bacula-4096-Distribution-Verification-key.asc
# Criar o repositório do Bacula Community
echo "# Bacula Community
deb http://www.bacula.org/packages/${bacula_key}/debs/${bacula_version}/${linux_name}/amd64/ ${linux_name} main" > /etc/apt/sources.list.d/bacula-community.list
###################################################################
# Instalar o Banco de Dados MySQL ou PostgreSQL
# Selecione os comandos de acordo com a opção desejada
#==================================================================
# Instalar o MySQL
wget -c https://repo.mysql.com/RPM-GPG-KEY-mysql -O /tmp/RPM-GPG-KEY-mysql --no-check-certificate
apt-key add /tmp/RPM-GPG-KEY-mysql
echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-apt-config
deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7
deb http://repo.mysql.com/apt/debian/ stretch mysql-tools
deb http://repo.mysql.com/apt/debian/ stretch mysql-tools-preview
deb-src http://repo.mysql.com/apt/debian/ stretch mysql-5.7" > /etc/apt/sources.list.d/mysql.list
apt-get update
apt-get install -y mysql-community-server
apt-get install -y bacula-mysql
systemctl enable mysql
systemctl start mysql
# Criar o banco de dados do Bacula com MySQL
/opt/bacula/scripts/create_mysql_database
/opt/bacula/scripts/make_mysql_tables
/opt/bacula/scripts/grant_mysql_privileges
#==================================================================
# Instalar PostgreSQL
apt-get update
apt-get install -y postgresql postgresql-client
apt-get install -y bacula-postgresql
# Habilitar e iniciar o PostgreSQL durante o boot
systemctl enable postgresql
systemctl start postgresql
# Criar o banco de dados do Bacula com PostgreSQL
su - postgres -c "/opt/bacula/scripts/create_postgresql_database"
su - postgres -c "/opt/bacula/scripts/make_postgresql_tables"
su - postgres -c "/opt/bacula/scripts/grant_postgresql_privileges"
###################################################################
usermod -aG tape bacula
usermod -aG disk bacula
# Habilitar o início dos daemons durante o boot
systemctl enable bacula-fd.service
systemctl enable bacula-sd.service
systemctl enable bacula-dir.service
# Iniciar os daemons do Bacula
systemctl start bacula-fd.service
systemctl start bacula-sd.service
systemctl start bacula-dir.service
# Criar atalho em /usr/sbin com os binários do Bacula
# Isso permite rodar os daemons e utilitários
# Sem entrar no diretório /opt/bacula/bin
for i in `ls /opt/bacula/bin`; do
    ln -s /opt/bacula/bin/$i /usr/sbin/$i;
done
# Substituir o endereço do bconsole.conf para localhost por padrão
sed '/[Aa]ddress/s/=\s.*/= localhost/g' -i  /opt/bacula/etc/bconsole.conf
Instalação Manual CentOS
#!/bin/bash
# Digite a versão desejada
bacula_version="11.0.5"
# Digite a chave recebida por email
bacula_key="XXXXXXXXXXXXX"
# Requisitos para instalar o Bacula por pacotes
yum install -y zip wget bzip2
# Download da chaves do repositório
wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc
# Adicionar chave no repositório local
rpm --import /tmp/Bacula-4096-Distribution-Verification-key.asc
# Criar o repositório do Bacula Community
echo "[Bacula-Community]
name=CentOS - Bacula - Community
baseurl=http://www.bacula.org/packages/${bacula_key}/rpms/${bacula_version}/el7/
enabled=1
protect=0
gpgcheck=0" > /etc/yum.repos.d/bacula-community.repo
###################################################################
# Instalar o Banco de Dados MySQL ou PostgreSQL
# Selecione os comandos de acordo com a opção desejada
#==================================================================
# Instalar o MySQL
rpm --import /tmp/RPM-GPG-KEY-mysql
wget -c http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm -O /tmp/mysql57-community-release-el7-9.noarch.rpm
rpm -ivh /tmp/mysql57-community-release-el7-9.noarch.rpm
yum install -y mysql-community-server
mysqld --initialize-insecure --user=mysql
systemctl enable mysqld
systemctl start mysqld
yum install -y bacula-mysql
# Criar o banco de dados do Bacula com MySQL
/opt/bacula/scripts/create_mysql_database
/opt/bacula/scripts/make_mysql_tables
/opt/bacula/scripts/grant_mysql_privileges
#==================================================================
# Instalar PostgreSQL
yum install -y postgresql-server
yum install -y bacula-postgresql --exclude=bacula-mysql
postgresql-setup initdb
# Habilitar e iniciar o PostgreSQL durante o boot
systemctl enable postgresql
systemctl start postgresql
# Criar o banco de dados do Bacula com PostgreSQL
su - postgres -c "/opt/bacula/scripts/create_postgresql_database"
su - postgres -c "/opt/bacula/scripts/make_postgresql_tables"
su - postgres -c "/opt/bacula/scripts/grant_postgresql_privileges"
###################################################################
usermod -aG tape bacula
usermod -aG disk bacula
# Desabilita selinux:
setenforce 0
sudo sed -i "s/enforcing/disabled/g" /etc/selinux/config
# Regras de Firewall
firewall-cmd --permanent --zone=public --add-port=9101-9103/tcp
firewall-cmd --reload
# Habilitar o início dos daemons durante o boot
systemctl enable bacula-fd.service
systemctl enable bacula-sd.service
systemctl enable bacula-dir.service
# Iniciar os daemons do Bacula
systemctl start bacula-fd.service
systemctl start bacula-sd.service
systemctl start bacula-dir.service
# Criar atalho em /usr/sbin com os binários do Bacula
# Isso permite rodar os daemons e utilitários
# Sem entrar no diretório /opt/bacula/bin
for i in `ls /opt/bacula/bin`; do
    ln -s /opt/bacula/bin/$i /usr/sbin/$i;
done
# Substituir o endereço do bconsole.conf para localhost por padrão
sed '/[Aa]ddress/s/=\s.*/= localhost/g' -i  /opt/bacula/etc/bconsole.conf