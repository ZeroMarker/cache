// /����: ������ع��÷���
// /����: ������ع��÷���
// /��д�ߣ�zhangdongmei
// /��д����: 2012.12.27

var gParam=[];

function GetParams(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url=DictUrl+'inadjpriceaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gParam=info.split('^');
		}
	}

	return;
}

//ȡ�Ƿ���ݶ������ͼ����ۼ۱�־:1:���㣻0��������
function GetCalSpFlag(){
	if(gParam.length<1){
		GetParams();
	}
	var flag=0;
	if(gParam.length>0){
		flag=gParam[0];
	}
	return flag;
}
//�Ƿ������һ�е�ֵĬ����¼�еĵ���ԭ��
function IfSetAspReason(){
	if(gParam.length<1){
		GetParams();
	}
	return gParam[1];
}
// ȡ�Ƿ���֤����ۼ۲���
function ValidateMaxSp(){
	if(gParam.length<1){
		GetParams();
		}
	return gParam[5];
	}