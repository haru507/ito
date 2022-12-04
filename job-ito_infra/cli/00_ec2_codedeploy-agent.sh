## CodeDeployエージェントインストール

sudo su -

# CodeDeployソースキットURL
export REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//g')
export RESOURCEKIT_URL="https://aws-codedeploy-${REGION}.s3.${REGION}.amazonaws.com/latest/install"

yum install ruby
# インストール:
#   ruby.x86_64 0:2.0.0.648-36.amzn2.0.1
#
# 依存性関連をインストールしました:
#   ruby-irb.noarch 0:2.0.0.648-36.amzn2.0.1                 ruby-libs.x86_64 0:2.0.0.648-36.amzn2.0.1
#   rubygem-bigdecimal.x86_64 0:1.2.0-36.amzn2.0.1           rubygem-io-console.x86_64 0:0.4.2-36.amzn2.0.1
#   rubygem-json.x86_64 0:1.7.7-36.amzn2.0.1                 rubygem-psych.x86_64 0:2.0.0-36.amzn2.0.1
#   rubygem-rdoc.noarch 0:4.0.0-36.amzn2.0.1                 rubygems.noarch 0:2.0.14.1-36.amzn2.0.1

cd /usr/local/src
wget ${RESOURCEKIT_URL}

chmod +x ./install

./install auto
# インストール:
#   codedeploy-agent.noarch 0:1.3.1-1880


## CodeDeployエージェントの起動確認
systemctl status codedeploy-agent

# スケールアウト時に起動するため自動起動を無効化
systemctl stop codedeploy-agent
systemctl disable codedeploy-agent

# 無効化確認
systemctl is-enabled codedeploy-agent