Processo de instalação do Bacula e baculum 

Faça o cadastro no site: https://www.bacula.org/bacula-binary-package-download/
Com o repositório enviado por e-mail, de inicio ao processo de instalação.

Script Instalação Automática Debian e CentOS (Criado por Wanderlei Huttel)
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

Mantenha seu SO atualizado na última versão dos pacotes para garantir que todas as versões disponíveis sejam compativéis.

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

###################################################################

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

###################################################################

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

###################################################################

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

###################################################################

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

###################################################################

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

###################################################################

Instalação Baculum e configuração inicial da API e Interface Web

1. Instalação
Baculum 9 funciona com outras versões do Bacula, mas apenas o Bacula 9 possui os binários json – necessários à configuração gráfica do Bacula.

Para instalar o Bacula 9 a partir do código fonte, acesse <http://www.bacula.com.br/compilacao>.

Uma vez que o Bacula está instalando e funcionando, pode-se prosseguir com a instalação da API Baculum e interface, como se segue.

###################################################################

2. Debian/Ubuntu
wget -qO - https://www.bacula.org/downloads/baculum/baculum.pub | apt-key add -
echo "
deb [ arch=amd64 ] https://www.bacula.org/downloads/baculum/stable-11/debian bullseye main
deb-src https://www.bacula.org/downloads/baculum/stable-11/debian bullseye main
" > /etc/apt/sources.list.d/baculum.list
apt-get update && apt-get install php-bcmath php*-mbstring baculum-api baculum-api-apache2 baculum-common bacula-console baculum-web baculum-web-apache2
echo "Defaults:apache "'!'"requiretty
www-data ALL=NOPASSWD: /usr/sbin/bconsole
www-data ALL=NOPASSWD: /usr/sbin/bdirjson
www-data ALL=NOPASSWD: /usr/sbin/bsdjson
www-data ALL=NOPASSWD: /usr/sbin/bfdjson
www-data ALL=NOPASSWD: /usr/sbin/bbconsjson
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl start bacula-dir
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl stop bacula-dir
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl restart bacula-dir
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl start bacula-sd
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl stop bacula-sd
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl restart bacula-sd
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl start bacula-fd
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl stop bacula-fd
www-data ALL=(root) NOPASSWD: /usr/bin/systemctl restart bacula-fd
www-data ALL=(root) NOPASSWD: /opt/bacula/bin/mtx-changer
" > /etc/sudoers.d/baculum
usermod -aG bacula www-data 
chown -R www-data:bacula /opt/bacula/working /opt/bacula/etc
chmod -R g+rwx /opt/bacula/working /opt/bacula/etc
a2enmod rewrite
a2ensite baculum-web baculum-api
service apache2 restart
sed -i 's/ident/trust/g; s/peer/trust/g; s/md5/trust/g' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/ident/trust/g; s/peer/trust/g; s/md5/trust/g' /etc/postgresql/*/main/pg_hba.conf
service postgresql restart
server_ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
echo "Acesse e configure pelo navegador de Internet a API http://$server_ip:9096/ e depois o Baculum http://$server_ip:9095/"

###################################################################

3. Centos/RedHat
rpm --import http://bacula.org/downloads/baculum/baculum.pub
echo "
[baculumrepo]
name=Baculum CentOS repository
baseurl=https://www.bacula.org/downloads/baculum/stable-11/centos
gpgcheck=1
enabled=1" > /etc/yum.repos.d/baculum.repo
yum install -y baculum-common baculum-api baculum-api-httpd baculum-web baculum-web-httpd
echo "Defaults:apache "'!'"requiretty
apache  ALL=NOPASSWD:  /usr/sbin/bconsole
apache  ALL=NOPASSWD:  /usr/sbin/bdirjson
apache  ALL=NOPASSWD:  /usr/sbin/bsdjson
apache  ALL=NOPASSWD:  /usr/sbin/bfdjson
apache  ALL=NOPASSWD:  /usr/sbin/bbconsjson
apache ALL=(root) NOPASSWD: /usr/bin/systemctl start bacula-dir
apache ALL=(root) NOPASSWD: /usr/bin/systemctl stop bacula-dir
apache ALL=(root) NOPASSWD: /usr/bin/systemctl restart bacula-dir
apache ALL=(root) NOPASSWD: /usr/bin/systemctl start bacula-sd
apache ALL=(root) NOPASSWD: /usr/bin/systemctl stop bacula-sd
apache ALL=(root) NOPASSWD: /usr/bin/systemctl restart bacula-sd
apache ALL=(root) NOPASSWD: /usr/bin/systemctl start bacula-fd
apache ALL=(root) NOPASSWD: /usr/bin/systemctl stop bacula-fd
apache ALL=(root) NOPASSWD: /usr/bin/systemctl restart bacula-fd
apache ALL=(root) NOPASSWD: /opt/bacula/bin/mtx-changer
" > /etc/sudoers.d/baculum
usermod -aG bacula apache
chown -R apache:bacula /opt/bacula/working /opt/bacula/etc
chmod -R g+rwx /opt/bacula/working /opt/bacula/etc
firewall-cmd --permanent --zone=public --add-port=9095-9096/tcp
firewall-cmd --reload
service httpd restart
systemctl enable httpd
sed -i 's/ident/trust/g; s/peer/trust/g' /var/lib/pgsql/data/pg_hba.conf
service postgresql restart
server_ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') 
echo "Acesse e configure pelo navegador de Internet a API http://$server_ip:9096/ e depois o Baculum http://$server_ip:9095/"

###################################################################

Configurações inicais de API e Interface Web

###################################################################

Usuário e senha padrão da API e Interface Web
Usuário: admin
Senha: admin

Acesse seu sua API pelo IP do servidor via browser, porta 9096, http://$server_ip:9096/
Insira as informações do Banco de dados, Postgre ou SQL e insira o IP do servidor e senha do banco se houver e teste. (tenha senha no banco, dã)

Na página seguinte, permita compartilhamento dos comandos do bconsole, marque a opção de sudo e substitua os caminhos:
Caminho para o bconsole: /usr/sbin/bconsole
Caminho do bconsole.conf: /opt/bacula/etc/bconsole.conf

Na página seguinte, marque novamente a opção de sudo e insira os seguintes caminhos:
Configuração geral: /opt/bacula/working

Director
Caminho do binário bdirjson: usr/sbin/bdirjson
Caminho da configuração do director (geralmente bacula-dir.conf): /opt/bacula/etc/bacula-dir.conf

Storage Daemon
Caminho do binário bsdjson: /usr/sbin/bsdjson
Caminho da config do storage (geralmente bacula-sd.conf): /opt/bacula/etc/bacula-sd.conf

File Daemon\client
Caminho do binário bfdjson: /usr/sbin/bfdjson
Caminho da configuração do file daemon (geralmente bacula-fd.conf): /opt/bacula/etc/bacula-fd.conf

Bconsole
Caminho do binário bbconsjson: /usr/sbin/bbconsjson
Caminho de configuração do Bconsole (geralmente bconsole.conf): /opt/bacula/etc/bconsole.conf

Teste as configurações, se estiver tudo certo, será marcado um OK em cada configuração.

Em autenticação, será necessário definir um usuário e senha para sua API, teste e estando tudo certo, prossiga para a configuração da Interface Web (não esquece de salvar)

Acesso a interface Web
http://$server_ip:9095/

A grosso modo, basta inserir o usuário e senha definidos na API e testar, dando certo, salve e você será encaminhado a tela de login do Baculum.
