///����:		���������ع�������������
///����:		���������ع�������������
///��д��:	wangjiabin
///��д����:	2014-04-11

//�������ֵ��object
var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
//��������ȫ�ֱ���
var INREQUEST_LOCTYPE = '';
if(InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc){
	INREQUEST_LOCTYPE = InRequestParamObj.ReqLocUseLinkLoc == 'Y'? 'L' : '';
}

/*��������������ԣ�
�Ƿ���Ҫ�������^�Ƿ���Ҫ�������
*/
var gParam=[]; 

function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.inrequestaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
GetParam();

///�Ƿ���Ҫ�������
function RecLocAuditRequired(){
	var result="";
	if (gParam.length>0) result=gParam[0];   
	return	result;
}

///�Ƿ���Ҫ�������
function ProvLocAuditRequired(){
	var result="";
	if (gParam.length>1) result=gParam[1];   
	return	result;
}

///return:��ʼ����
function DefaultStDate(){
	if(gParam.length<1){
		GetParam();
	}
	var today=new Date();
	if(gParam.length<3){
		return today;
	}
	
	var defaStDate=gParam[2];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

///return:��ֹ����
function DefaultEdDate(){
	if(gParam.length<1){
		GetParam();
	}
	var today=new Date();
	if(gParam.length<4){
		return today;
	}

	var defaEdDate=gParam[3];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}

function IsSplit()
{
	if(gParam.length<1){
		GetParam();
	}

	return gParam[4];
	}
	