git@github.com:zlyysf/quiz.git
����Ŀ¼���ư������� iphone, ui.



ע����Ҫ�Ȳο���ƪ�ĵ���    https://help.github.com/articles/generating-ssh-keys
ע���������� passphrase �ĵط��ܿ���գ��ܶ���̡�
ע���step4���ᵽ�� ~/.ssh/id_rsa.pub ����lingzhi����Ա������ȥ���á�

�½�һ��Ŀ¼�����룬ִ��
git clone git@github.com:zlyysf/quiz.git ./
�ڱ��ؽ�����֧ workMaster����ӦԶ�̵� workMaster���Ժ��޸��ύ�������֧���С�
git branch workMaster origin/workMaster
git checkout workMaster
�������Ͻ��飬����rebaseѡ��
git config branch.workMaster.rebase true


�Ժ�git pushʱʹ���������� 
git push origin workMaster:workMaster

(�ڱ��صķ�֧workMaster����pull�������� git checkout workMaster ����֤��workMaster�£�����ʹ��git branch���鿴)
git pull --progress origin workMaster



����һЩ���ò鿴����
git branch -a
git remote -v
cat .git/config




