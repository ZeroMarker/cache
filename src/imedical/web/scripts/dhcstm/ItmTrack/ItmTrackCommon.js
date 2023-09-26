//����: ��ֵ������ع�������������
//wangjiabin	2013-10-16

//�������ֵ��object
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');

/*��������������ԣ�
 *  ���ʿ��Ƿ�ʹ�ø�ֵ���ٹ���^Ĭ�ϲ�����ʼ����^Ĭ�ϲ��ҽ�ֹ����
*/
var gItmTrackParam=[];

//ȡ��ֵ���ٲ���
function GetItmTrackParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.itmtrackaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gItmTrackParam=info.split('^');
		}
	}

	return;
}

//��ʼ����
function DefaultStDate(){
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
	}
	var today=new Date();
	if(gItmTrackParam.length<2){
		return today;
	}
	
	var defaStDate=gItmTrackParam[1];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

//��������
function DefaultEdDate(){
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
	}
	var today=new Date();
	if(gItmTrackParam.length<3){
		return today;
	}

	var defaEdDate=gItmTrackParam[2];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}

/**
 * ������������ϵ,��Scg��CheckScg������,����true, ���򷵻�false
 * @param {} CheckScg
 * @param {} Scg
 * @return {Boolean}
 */
function CheckScgRelation(CheckScg, Scg){
	if(Ext.isEmpty(CheckScg) || Ext.isEmpty(Scg)){
		return true;
	}
	var ChildScg = tkMakeServerCall('web.DHCSTM.Common.DrugInfoCommon', 'GetAllChildScgStr', CheckScg, ',');
	var ChildScgArr = ChildScg.split(',');
	return (ChildScgArr.indexOf(Scg) >= 0);
}

function TypeRenderer(value){
	var TypeDesc=value;
	if(value=="G"){
		TypeDesc="���";
	}else if(value=="R"){
		TypeDesc="�˻�";
	}else if(value=="T"){
		TypeDesc="ת�Ƴ���";
	}else if(value=="K"){
		TypeDesc="ת�ƽ���";
	}else if(value=="P"){
		TypeDesc="סԺҽ��";
	}else if(value=="Y"){
		TypeDesc="סԺҽ��ȡ��";
	}else if(value=="MP"){
		TypeDesc="סԺҽ��";
	}else if(value=="MY"){
		TypeDesc="סԺҽ��ȡ��";
	}else if(value=="A"){
		TypeDesc="������";
	}else if(value=="D"){
		TypeDesc="��汨��";
	}else if(value=="F"){
		TypeDesc="����ҽ��";
	}else if(value=="H"){
		TypeDesc="����ҽ��ȡ��";
	}else if(value=="MF"){
		TypeDesc="����ҽ��";
	}else if(value=="MH"){
		TypeDesc="����ҽ��ȡ��";
	}else if(value=="RD"){
		TypeDesc="����";
	}else if(value=="PD"){
		TypeDesc="�ɹ�";
	}else if(value=="POD"){
		TypeDesc="����";
	}else if(value=='SG'){
		TypeDesc="��¼���";
	}else if(value=='ST'){
		TypeDesc="��¼����";
	}else if(value=='SK'){
		TypeDesc="��¼����-����";
	}else if(value=='SR'){
		TypeDesc="��¼���-�˻�";
	}else if(value=='SP'){
		TypeDesc="��¼ҽ������";
	}
	return TypeDesc;
}
function PrintRenderer(value){
	var printFlag=value;
	if (value=="Y"){
	   printFlag="�Ѵ�ӡ";
	}
	return printFlag;
}
function statusRenderer(value){
    var Status=value;
	if (value=="Enable"){
	   Status="����";
	}
	else if(value=="Return"){
		Status="�˻�";
	}
	else if(value=="Used"){
		Status="��ʹ��";
	}
	else if(value=="InScrap"){
		Status="����";
	}
	else if(value=="InAdj"){
		Status="����";
	}
	else{
		Status=value;
	}
	return Status;
}
