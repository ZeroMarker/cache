/*
 * FileName:	matntrtreg.js
 * User:		JinS
 * Date:		2021-11-29
 * Function:	生育待遇备案(医保办)
 */
 
// 定义常量
var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,  //院区ID
	USERID:session['LOGON.USERID'] ,  //操作员ID
	GROUPID:session['LOGON.GROUPID'], //安全组id
	ADMID:'',
	SelADMID:'',                       
	PAPMI:'',
	INSUADMID : '',
	MatnRowid:'',      //生育备案表rowid
	fixmedinsCode:'H36011100214',
	fixmedinsName:'南昌市第九医院',
	PoolareaNo:'360100',
	InsuAdmDvs:'360100',                      //患者参保地编码 
	OpterId:'',
	OpterDate :'',
	OpterTime :''    

}
var index=1
//入口函数
$(function(){
	setPageLayout();    //设置页面布局
	setElementEvent();	//设置页面元素事件
	
	
    
});

//设置页面布局
function setPageLayout(){
	
	// 医保类型
	init_INSUType();
	
	// 查询面板医保类型
	init_SearchInsuType();
	
	// 就诊记录
	initAdmList();
		
	//初始化生育待遇备案记录	
	init_dg();
	
	//日期初始化	
	init_Date();
	
	//布局初始化-Size
	//init_layout();
    //清屏
	clear();
}


//设置页面元素事件
function setElementEvent()
{
	//页面进行刷新
	$(document).keydown(function(e){
	 	banBackSpace(e);
	 	});
 	window.onresize=function(){
    	location.reload();
 	} 
 
	//备案登记
	$("#btnRefer").click(MatnTrtReg_Click);
	
    //备案撤销
    $("#btnReferDes").click(MatnTrtRegDestory_Click); 
     
     //备案删除
     $("#btncancel").click(delect); 
    //备案查询
    $("#btnSearch").click(FixRegsearch_Click); 
    
    //查询
    $("#btnFind").click(initLoadGrid); 
    
    
 
	//卡号回车查询事件
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//备案查询
	//人员编号回车查询事件
	$("#SearchInsuNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//证件号码回车查询事件
	$("#SearchId").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//人员姓名回车查询事件
	$("#SearchName").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
}

/*
*功能授权
*/
function BtnAuthor()
{
	//enableById("AdmList"); 
	if(GV.GROUPID=="17"){
		//disableById("btnReferCret");    
		$('#btnReferCret').attr('style','display:none')
	}else{
		//非医保办，获取人员信息、备案、备案撤销、备案查询均不可见
		$('#btn-readINSUCard').attr('style','display:none')
		$('#btnRefer').attr('style','display:none')
		$('#btnReferDes').attr('style','display:none')
		$('#btnSearch').attr('style','display:none')

	}
	
}
//删除
function delect(){
	
	
	var dgSelect = $('#dg').datagrid('getSelected');
	var RowId = '';
	var TValiFlag='';
	if(dgSelect){
		RowId = dgSelect.TRowid;	
		TValiFlag=dgSelect.TValiFlag
	}
	if (RowId == ''){
		$.messager.alert("温馨提示","请选择要删除的行!", 'info')
	
		return;	
	}	
	
    if (TValiFlag =="备案成功"){
		$.messager.alert("温馨提示","备案成功记录不能删除!", 'info')
		return;	
	}	
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
		if(fb){
			var rtn = $.m({ClassName: "INSU.MI.BL.MatnTrtRegCtl", MethodName: "Delete", RowId:RowId,}, false);
	  if (rtn == '0'){
		$.messager.alert("温馨提示",'删除成功' , 'info');
		initLoadGrid();
	  }else{
		$.messager.alert("温馨提示",'删除失败'  + rtn , 'info');
		initLoadGrid();
	}
		}else{
			return;	
		}
	});
}
//保存
function MatnTrtMod_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	var Rowid=GV.MatnRowid;
	var PapmiDr="";                            //基本信息表Dr
	var HiType=getValueById('QInsuType');
	var InStr="",ExpStr="";
	var InStr=Rowid+"^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType; 
	//人员编号^人员证件类型^证件号码^人员姓名^民族^性别^出生日期^孕周数^生育待遇申报人类别^计划生育服务证号^末次月经日期^预计生育日期^ 5-16
	//配偶姓名^配偶证件类型^配偶证件号码^定点医药机构编号^定点医药机构名称^开始日期^结束日期^统筹区编号^联系电话^联系地址^胎次^生育类别^ 17-28
	//参保所属医保区划^险种类型^待遇申报明细流水号^有效标志^单位编号^单位名称^人员参保关系ID^经办机构编号^经办人姓名^门诊检查报销标准^ 29-38
	//生育资格登记状态^申报日期^字段扩展^扩展参数1^扩展参数2^代办人姓名^代办人证件类型^代办人证件号码^代办人联系方式^代办人联系地址^ 39-48
	//代办人关系^备注^经办人ID^经办日期^经办时间^更新人ID^更新日期^更新时间 49-56
	//^2^^^00A^测试^411481199910105177^^^^5^1^11^^^111^01^111^H44022200010^始兴县人民医院^2022-02-16^2022-12-07^440222^18137077186^111111^1^7
	//^^310^1^A^^^^H44022200010^^^A^2022-12-1^^^^111^01^111^11^^1^^^^^909^2022-12-1^14:36:1
	var psnNo=getValueById('psnNo');
	InStr=InStr+"^"+psnNo;                                       			//人员编号   医保登记表INADM_InsuId
	
	var PsnCertType=getValueById('PsnCertType');

	InStr=InStr+"^"+PsnCertType;                                       		//人员证件类型
	
	var Certno=getValueById('Certno');
	if(Certno == "")
	{
		$.messager.alert("温馨提示","孕妇证件号码不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+Certno;                                       			//证件号码
	
	var name=getValueById('name');
	if(name == "")
	{
		$.messager.alert("温馨提示","孕妇姓名不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+name;                                       			//人员姓名
	
	InStr=InStr+"^"+getValueById('Naty');                                 	//民族
	
	var Sex=getValueById('Sex');                                            //性别
	
	 
	InStr=InStr+"^"+Sex;                                 		             
	
	InStr=InStr+"^"+getValueById('BrDate');                               	//出生日期
	
	var GesoVal=getValueById('GesoVal');                                                                                                
	if(GesoVal != "")                                                       //upt 20220429 HanZH 验证孕周数数据类型
	{
		if (isNaN(GesoVal)){
			$.messager.alert("温馨提示","孕周数请输入数值!", 'info');
			return;
　　	}
	}else{
		$.messager.alert("温馨提示","孕周数不能为空!", 'info');
			return;
	}
	
	InStr=InStr+"^"+GesoVal;                                             	//孕周数
	
	var MatnTrtDclaerType=getValueById('MatnTrtDclaerType');
	if(MatnTrtDclaerType == "")
	{
		$.messager.alert("温馨提示","生育待遇申报人类别不能为空!", 'info');
		return ; 
	}
	InStr=InStr+"^"+MatnTrtDclaerType;                                     //生育待遇申报人类别
	
	InStr=InStr+"^"+getValueById('FpscNo');                                //计划生育服务证号
	
	var LastMenaDate=getValueById('LastMenaDate');
	if(LastMenaDate==""){
		$.messager.alert("温馨提示","孕妇末次月经日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+LastMenaDate;                          				   //末次月经日期
	
	var PlanMatnDate=getValueById('PlanMatnDate');
	if(PlanMatnDate==""){
		$.messager.alert("温馨提示","孕妇预计生育日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+PlanMatnDate;                                        	//预计生育日期
	
	var SpusName="";
	var SpusCertType="";
	var SpusCertNo=""
	SpusName=getValueById('SpusName');
	SpusCertType=getValueById('SpusCertType');
	SpusCertNo=getValueById('SpusCertNo')
	
	InStr=InStr+"^"+SpusName;                                            //配偶姓名
	InStr=InStr+"^"+SpusCertType;                                        //配偶证件类型
	InStr=InStr+"^"+SpusCertNo;                                          //配偶证件号码
	
	if(Sex=="1" || Sex=="男" || Sex=="男性"){
		if(SpusName=="" || SpusCertType =="" || SpusCertNo==""){
			
			$.messager.alert("温馨提示","男性参保人以下信息不能为空：配偶姓名;配偶证件类型;配偶证件号码!")
			return ;
			}
		
	}
		
	InStr=InStr+"^"+GV.fixmedinsCode;                          //定点医药机构编号
	InStr=InStr+"^"+GV.fixmedinsName;                          //定点医药机构名称
	
	var SDate=getValueById('SDate');	
	if(SDate == "")
	{
		$.messager.alert("温馨提示","产检开始日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+SDate;                                        	        //开始日期
	
	var EDate=getValueById('EDate');	
	if(EDate == "")
	{
		$.messager.alert("温馨提示","产检结束日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+EDate;                                        	        //结束日期
	
	InStr=InStr+"^"+GV.PoolareaNo;                                          //医院所在统筹区编号
	
	var telNo=getValueById('tel');
	if(telNo == "")
	{
		$.messager.alert("温馨提示","联系电话不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+telNo;                                            //联系电话
	
	var addr=getValueById('addr');

	InStr=InStr+"^"+addr;                                             //联系地址
	
	var Fetts=getValueById('Fetts');	
	if(Fetts != "")
	{
		if (isNaN(Fetts)){
			$.messager.alert("温馨提示","胎次请输入数值!", 'info');
			return;
　　	}
	}else{
		$.messager.alert("温馨提示","胎次不能退为空!", 'info');
		return;
	}
	InStr=InStr+"^"+Fetts;                                               //胎次  upt 20220429 HanZH 验证胎次数据类型
		
	var MatnType=getValueById('MatnType');
	if(MatnType == "")
	{
		$.messager.alert("温馨提示","生育类别不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+MatnType;                                             //生育类别
	
	var InsuAdmdvs=GV.InsuAdmDvs                                          //参保所属医保区划
	InStr=InStr+"^"+InsuAdmdvs;               
	
	var InsuType=getValueById('InsuType');
	if(InsuType == "")
	{
		$.messager.alert("温馨提示","险种类型不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+InsuType;                                               //险种类型
	
	var TrtDclaDetlSn="1"                                                   //待遇申报明细流水号(登记返回)
	InStr=InStr+"^"+TrtDclaDetlSn;  
	
	var ValiFlag="D"                                                        //有效标志(D:待备案、A已备案、S备案撤销)
	InStr=InStr+"^"+ValiFlag;   
	
	InStr=InStr+"^"+"";                                	                    //单位编号
	InStr=InStr+"^"+"";                              	                    //单位名称
	
	var PsnInsuRltsId=""	                                                //人员参保关系ID
	InStr=InStr+"^"+PsnInsuRltsId;
	var OptinsNo=GV.fixmedinsCode  		                                    //经办机构编号
	InStr=InStr+"^"+OptinsNo; 
	var OpterName=""   		                                                //经办人姓名
	InStr=InStr+"^"+OpterName; 
	var OtpExamReimStd=""                                                   //门诊检查报销标准
	InStr=InStr+"^"+OtpExamReimStd; 
	var MatnQuaRegStas="A"                                                  //生育资格登记状态
	InStr=InStr+"^"+MatnQuaRegStas;
	 
	InStr=InStr+"^"+"";                              	                    //申报日期
	
	var ExpContent=""                                                       //字段扩展
	InStr=InStr+"^"+ExpContent; 
	InStr=InStr+"^"+"";                                                     //扩展参数1
	InStr=InStr+"^"+"";                                                     //扩展参数2
	
	InStr=InStr+"^"+getValueById('AgnterName');                           	//代办人姓名
	InStr=InStr+"^"+getValueById('AgnterCertType');                       	//代办人证件类型
	InStr=InStr+"^"+getValueById('AgnterCertno');                         	//代办人证件号码
	InStr=InStr+"^"+getValueById('AgnterTel');                            	//代办人联系方式
	InStr=InStr+"^"+getValueById('AgnterAddr');                           	//代办人联系地址
	InStr=InStr+"^"+getValueById('AgnterRlts');                           	//代办人关系
	
	var memo=getValueById('reflRea');                                          //备注
	InStr=InStr+"^"+memo;  
	
	var OpterId=""                                                      //经办人(填写人,修改人)-----医师，不管哪个医师
	var OptDate="" ;                                                        //经办日期（填写日期）
	var OptTime="" ;                                                        //经办时间（填写时间）
	
	if (GV.OpterId!=""){OpterId=GV.OpterId}	
	if (GV.OpterDate!=""){OptDate=GV.OpterDate}
	if (GV.OpterTime!=""){OptTime=GV.OpterTime}                             //如果医师填写的，填写人不能变	
		
		
	InStr=InStr+"^"+OpterId+"^"+OptDate+"^"+OptTime; 
	var today=new Date();
	var NowDate=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
	var NowTime=today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
	var UpdtId=UserId                                                          //更新人（备案人）-----医保办人员，不分人
	var UpdtDate=NowDate                                                        //更新日期
	var UpdtTime=NowTime                                                       //更新时间
	InStr=InStr+"^"+UpdtId+"^"+UpdtDate+"^"+UpdtTime;
	
	$.messager.progress({
		title: "提示",
		text: '正在修改备案数据,请稍后....'
	});
	
	$m({
		ClassName:"INSU.MI.BL.MatnTrtRegCtl",
		MethodName:"InsertMatnTrtReg",
		InString:InStr,
		HospDr:GV.HospDr,
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('提示',"修改生育备案数据失败："+rtn);
			initLoadGrid();
		}else{
			   
			   $.messager.alert('提示','修改生育备案数据成功');
			   initLoadGrid();	
			}
	  $.messager.progress("close");
	});	 
	initLoadGrid();	
	
	
}
//1101获取人员信息
function getPersonInfo()
{

var selected = $('#dg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("温馨提示","请选择一条备案记录!", 'info');
	}
	
	else{
			
    var MatnID=selected.TRowid;  //记录rowid
    

	var MatnInfo=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetMatnTrtRegById",MatnID);
	var MatnArr=MatnInfo.split("^");
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('QInsuType')+"^"+"1101"+"^^output^"+connURL;
	var QryParams=""

	QryParams=AddQryParam(QryParams,"mdtrt_cert_type","02");
	QryParams=AddQryParam(QryParams,"mdtrt_cert_no",MatnArr[7]);
	QryParams=AddQryParam(QryParams,"card_sn","");
	QryParams=AddQryParam(QryParams,"begntime","");
	QryParams=AddQryParam(QryParams,"psn_cert_type","");
	QryParams=AddQryParam(QryParams,"certno","");
	QryParams=AddQryParam(QryParams,"psn_name","");
	ExpStr=ExpStr+"^"+QryParams
	

	var rtn=InsuServQry(0,GV.USERID,ExpStr); 
	if (!rtn){return ;}
	if (rtn.split("^")[0]!="0") 
	 {
		$.messager.alert("提示","查询失败!rtn="+rtn, 'error');
		return ;
	}
	 var outPutObj=JSON.parse(rtn.split("^")[1]);
	 
	return outPutObj;
	}
}
function AddQryParam(QryArgs,name,value){
	return QryArgs+="&"+name+"="+value;
}
/**
*生育登记备案
*/
function MatnTrtReg_Click()
{
	
	var obj=$('#btnRefer').linkbutton("options")
	if (obj.disabled==true){return ;}
	
	disableById("btnRefer");
	
	
	  try {
	
  
  
	var selected = $('#dg').datagrid('getSelected');
	
	if (!selected || selected.TValiFlag=="备案成功") {
	   $.messager.alert("温馨提示","请选择一条待备案记录!", 'info');
	}
	
	else{
    var MatnID=selected.TRowid;  //记录rowid
    
	var MatnInfo=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetMatnTrtRegById",MatnID);
	var MatnArr=MatnInfo.split("^");
    
	var today=new Date();

	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	var Rowid=MatnID;
	
	var PapmiDr="";  //基本信息表Dr
	var HiType=getValueById('QInsuType');
	//var DclaSouc=1;  //申报来源 1 医院 2 中心
	var InStr="",ExpStr="";
	var InStr=Rowid+"^"+HospId+"^"+"1"+"^"+"1"+"^"+HiType; 
	if(getValueById('QInsuType')==''){
		$.messager.alert('提示', "医保类型不能为空" + str, 'error');	
		return;	
	}
	//var InStr=Rowid+"^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType; 
	//人员编号^人员证件类型^证件号码^人员姓名^民族^性别^出生日期^孕周数^生育待遇申报人类别^计划生育服务证号^末次月经日期^预计生育日期^ 5-16
	//配偶姓名^配偶证件类型^配偶证件号码^定点医药机构编号^定点医药机构名称^开始日期^结束日期^统筹区编号^联系电话^联系地址^胎次^生育类别^ 17-28
	//参保所属医保区划^险种类型^待遇申报明细流水号^有效标志^单位编号^单位名称^人员参保关系ID^经办机构编号^经办人姓名^门诊检查报销标准^ 29-38
	//生育资格登记状态^申报日期^字段扩展^扩展参数1^扩展参数2^代办人姓名^代办人证件类型^代办人证件号码^代办人联系方式^代办人联系地址^ 39-48
	//代办人关系^备注^经办人ID^经办日期^经办时间^更新人ID^更新日期^更新时间 49-56
	
	
	
	var outPutObj=getPersonInfo();
	if(!outPutObj){return ;}
		
	var psnNo=outPutObj.baseinfo.psn_no;
	if(psnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+psnNo;                                       			//人员编号
	
	
	var PsnCertType=MatnArr[6];
	if(PsnCertType == "")
	{
		$.messager.alert("温馨提示","人员证件类型不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+PsnCertType;                                       		//人员证件类型
	
	var Certno=MatnArr[7];
	if(Certno == "")
	{
		$.messager.alert("温馨提示","证件号码不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+Certno;                                       			//证件号码
	
	
	var name=MatnArr[8];
	if(name == "")
	{
		$.messager.alert("温馨提示","孕妇姓名不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+name;                                       			//人员姓名
	var Sex=MatnArr[10];                                            //性别
	 if(Sex==""){Sex="2"}
	InStr=InStr+"^"+Sex; 
	                                		             
	InStr=InStr+"^"+"01";                                 	//民族
	InStr=InStr+"^"+MatnArr[11];                               	//出生日期
	
	var GesoVal=MatnArr[12];           
	                                                                                 
	if(GesoVal != "")                                                       //upt 20220429 HanZH 验证孕周数数据类型
	{
		if (isNaN(GesoVal)){
			$.messager.alert("温馨提示","孕周数请输入数值!", 'info');
			return;
　　	}
	}else{
		$.messager.alert("温馨提示","孕周数不能为空!", 'info');
			return;
		}
	InStr=InStr+"^"+GesoVal;                                             	//孕周数
	
	var MatnTrtDclaerType=MatnArr[13];
	if(MatnTrtDclaerType == "")
	{
		$.messager.alert("温馨提示","生育待遇申报人类别不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+MatnTrtDclaerType;                                     //生育待遇申报人类别
	

	
	InStr=InStr+"^"+MatnArr[14];                                //计划生育服务证号
	
	
	var LastMenaDate=MatnArr[15];
	if(LastMenaDate==""){
		$.messager.alert("温馨提示","孕妇末次月经日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+LastMenaDate;                          				   //末次月经日期
	
	var PlanMatnDate=MatnArr[16];
	if(PlanMatnDate==""){
		$.messager.alert("温馨提示","孕妇预计生育日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+PlanMatnDate;                                        	//预计生育日期
	
	var SpusName="";
	var SpusCertType="";
	var SpusCertNo=""
	SpusName=MatnArr[17];
	SpusCertType=MatnArr[18];
	SpusCertNo=MatnArr[19]
	
	
	InStr=InStr+"^"+SpusName;                                             //配偶姓名
	InStr=InStr+"^"+SpusCertType;                                        //配偶证件类型
	InStr=InStr+"^"+SpusCertNo;                                          //配偶证件号码
	
	if(Sex=="1" || Sex=="男" || Sex=="男性"){
		if(SpusName=="" || SpusCertType =="" || SpusCertNo==""){
			
			$.messager.alert("温馨提示","男性参保人以下信息不能为空：配偶姓名;配偶证件类型;配偶证件号码!")
			return ;
			}
		
	}
	
	/*var fixmedinsCode=getValueById('fixmedinscode');
	if(fixmedinsCode == "")
	{
		$.messager.alert("温馨提示","定点医药机构编号不能为空!", 'info');
		return ;
	}*/
 
	InStr=InStr+"^"+GV.fixmedinsCode;                          //定点医药机构编号
	InStr=InStr+"^"+GV.fixmedinsName;                          //定点医药机构名称
	
	var SDate=MatnArr[22];	
	if(SDate == "")
	{
		$.messager.alert("温馨提示","开始日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+SDate;                                        	        //开始日期
	
	var EDate=MatnArr[23];	
	if(EDate == "")
	{
		$.messager.alert("温馨提示","结束日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+EDate;                                        	        //结束日期
	
	InStr=InStr+"^"+GV.PoolareaNo ;                                        //医院所在统筹区编号
	
	var telNo=MatnArr[25];
	if(telNo == "")
	{
		$.messager.alert("温馨提示","联系电话不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+telNo;                                            //联系电话
	
	var addr=MatnArr[26];

	InStr=InStr+"^"+addr;                                             //联系地址
	
	var Fetts=MatnArr[27];	
	if(Fetts != "")
	{
		if (isNaN(Fetts)){
			$.messager.alert("温馨提示","胎次请输入数值!", 'info');
			return;
　　	}
	}else{
		
		}
	InStr=InStr+"^"+Fetts;                                             //胎次  upt 20220429 HanZH 验证胎次数据类型
	
	var MatnType=MatnArr[28];
	if(MatnType == "")
	{
		$.messager.alert("温馨提示","生育类别不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+MatnType;                                          //生育类别
	
	var InsuAdmdvs=GV.InsuAdmDvs;                                    //参保所属医保区划
	InStr=InStr+"^"+InsuAdmdvs;               
	
	var InsuType=getValueById('InsuType');
	if(InsuType == "")
	{
		$.messager.alert("温馨提示","险种类型不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+InsuType;                                          //险种类型
	
	
	var TrtDclaDetlSn="1"                                    //待遇申报明细流水号(登记返回)
	InStr=InStr+"^"+TrtDclaDetlSn;  
	
	//var ValiFlag=MatnArr[32]                                                   //有效标志
	var ValiFlag="D"      
	InStr=InStr+"^"+ValiFlag;   
	
	InStr=InStr+"^"+"";                                	           //单位编号
	InStr=InStr+"^"+"";                              	           //单位名称
	
	var PsnInsuRltsId=""	                                                 //人员参保关系ID
	InStr=InStr+"^"+MatnArr[35];
	var OptinsNo=""   		                                               //经办机构编号
	InStr=InStr+"^"+GV.fixmedinsCode ; 
	var OpterName=""   		                                           //经办人姓名
	InStr=InStr+"^"+OpterName; 
	var OtpExamReimStd=""                                            //门诊检查报销标准
	InStr=InStr+"^"+"0"+OtpExamReimStd; 
	
	var MatnQuaRegStas="A"                                                 //生育资格登记状态
	InStr=InStr+"^"+MatnQuaRegStas;
	var NowDate=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
	var NowTime=today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
	InStr=InStr+"^"+NowDate;                              	                     //申报日期，当前日期
	
	var ExpContent=""                                                          //字段扩展
	InStr=InStr+"^"+ExpContent; 
	InStr=InStr+"^"+"";                                                      //扩展参数1
	InStr=InStr+"^"+"";                                                      //扩展参数2
	
	InStr=InStr+"^"+MatnArr[45];                           	//代办人姓名
	InStr=InStr+"^"+MatnArr[46];                       	//代办人证件类型
	InStr=InStr+"^"+MatnArr[47];                         	//代办人证件号码
	InStr=InStr+"^"+MatnArr[48];                            	//代办人联系方式
	InStr=InStr+"^"+MatnArr[49];                           	//代办人联系地址
	InStr=InStr+"^"+MatnArr[50];                           	//代办人关系
	
	var memo=MatnArr[51];                                          //备注
	InStr=InStr+"^"+memo;  
	
	var OpterId=""                                                          //经办人
	var OptDate="" ;                                                        //经办日期
	var OptTime="" ;                                                        //经办时间
	
	if (GV.OpterId!=""){OpterId=GV.OpterId}	
	if (GV.OpterDate!=""){OptDate=GV.OpterDate}
	if (GV.OpterTime!=""){OptTime=GV.OpterTime}                             //如果医师填写的，填写人不能变
	
	InStr=InStr+"^"+OpterId+"^"+OptDate+"^"+OptTime; 
	
	var UpdtId=UserId                                                        //更新人
	var UpdtDate=NowDate                                                         //更新日期
	var UpdtTime=NowTime                                                          //更新时间
	InStr=InStr+"^"+UpdtId+"^"+UpdtDate+"^"+UpdtTime;
	var ExpStr=getValueById('QInsuType')+"^";                                     //医保类型^数据库连接串
	var rtn=INSUMatnTrtReg(Handle,UserId,AdmDr,InStr,ExpStr)
	if (rtn!="0") 
	 {
		if(Rowid!=""){
			//更新状态为备案失败
			
			var UpdtInfo="F^"+UpdtId
			var Trtn=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","UpdtMatnTrtRegByRowid",Rowid,UpdtInfo,GV.HospDr)
			
			$.messager.alert("提示","生育备案登记失败!rtn="+rtn, 'error');
			}
		return ;
	}
	else{
		$.messager.alert('提示','生育备案登记成功');
		return ;
	}
	}    
	} catch (error) {
  }
	finally{
		enableById("btnRefer");
		}                   
}			
//生育登记备案撤销
function MatnTrtRegDestory_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "" && selected.TValiFlag=="备案成功") {
			
			$.messager.confirm('确认', '确认撤销备案记录？', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr,PsnNo=selected.TPsnNo,HiType=getValueById('QInsuType');
					
					
					
    				//var ExpString="需要重新备案" //格式:^^^数据库连接串
    				var ExpString=HiType+"^^"+"患者要求"+"^" //格式:^^撤销原因^数据库连接串
    				
    				//alert(UserId+"^"+AdmDr+"^"+PsnNo+"^"+HiType)
    				//AdmDr="386"//获取院区自定义
    			
					var rtn=INSUMatnTrtRegDestory(Handle, UserId , AdmDr ,PsnNo, ExpString); //DHCINSUPort.js
					
				   
					if (rtn!="0") 
	 				{
						$.messager.alert("提示","生育待遇备案撤销失败!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("提示","生育待遇备案撤销成功!", 'info',function(){
							initLoadGrid();	
						});
					}
				}
			});
		}else{
			$.messager.alert('提示', "请选择要撤销的【已备案】记录", 'info');		
			return false;
		}
	}
	else{
			$.messager.alert('提示', "请选择要撤销的记录", 'info');		
			return false;
		}
}
//备案查询
function FixRegsearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //格式:^^^数据库连接串
			//var rtn=InsuTransferHospQuery(Handle,UserId,selected.TRowid,ExpString); //DHCINSUPort.js
			var rtn="0"
			if (rtn!="0"){
				$.messager.alert("温馨提示","查询备案信息失败", 'info');
				return ;
			}else{
				$.messager.alert("温馨提示","查询备案信息成功", 'info');
				return ;
			}
		}	
	}else{
		$.messager.alert('提示', "请选择要查询的记录", 'info');		
		return false;
	}	
}
//初始化定点医院
function init_FixmedHosp(){
	
    var data={total:0,rows:[]};
	$('#fixmedinsname').combogrid({
    panelWidth:450,
    value:'006',
    idField:'fixmedins_code',
    textField:'fixmedins_name',
    delay: 600,
	mode: 'remote',
	method: 'GET',
	pagination: true,
    columns:[[
        {field:'fixmedins_code',title:'定点机构代码',width:160},
        {field:'fixmedins_name',title:'定点机构名称',width:270}
    ]],
    onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (($.trim(param.q).length >= 1)) {
				  param.q=param.q.replace("，",",");
				 if (param.q.indexOf(",")<=-1){
				  var ExpStr = "1^"+param.q+"^^^00A"
				  var jsonstr=InsuGetHosp(1,GV.USERID,ExpStr); //DHCINSUPort.js
				  var rows=JSON.parse(jsonstr);
				   data={total:rows.length,rows:rows};
				  $("#fixmedinsname").combogrid("grid").datagrid({data:data});
				 }
				 else
				 {
					 var newRows =data.rows.filter(function(item,index,array){
						 return (param.q.split(",")[1]!=""&&item.fixmedins_name.indexOf(param.q.split(",")[1])>=0);
						 });
						 
				     if (newRows.length>0){
					     var newData={total:newRows.length,rows:newRows};
					     }else{
						        newData=data; 
						     }
					 $("#fixmedinsname").combogrid("grid").datagrid({data:newData});
			    }
			}else{
				$('#fixmedinsname').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('fixmedinscode',row.fixmedins_code);
		}
});
}
//初始化就诊记录
function initAdmList() {
	$HUI.combogrid("#AdmList", {
		panelWidth: 560,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		pagination: true,
		pageSize: 1000,
		pageList: [1000],
		method: 'GET',
		idField: 'admId',
		textField: 'admNo',
		columns: [[{field: 'admNo', title: "就诊号", width: 100},
					{field: 'admStatus', title: '就诊类型', width: 80},
					{field: 'admDate', title: '就诊日期', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'admDept', title: '就诊科室', width: 100},
					{field: 'admWard', title: '就诊病区', width: 120},
					{field: 'admBed', title: '床号', width: 60},

					{field: 'admId', title: '就诊ID', width: 80},
					{field: 'patName', title: '姓名', width: 80,hidden:true},
					{field: 'PaSex', title: '性别', width: 80,hidden:true},
					{field: 'PAPMIHealthFundNo', title: '医保手册号', width: 80,hidden:true}
			]],
		onLoadSuccess: function (data) {
			    var admIndexEd=data.total;
                if (admIndexEd>0)
                {
	                var admdg = $('#AdmList').combogrid('grid');	
                    admdg.datagrid('selectRow',admIndexEd-1);	
                   
	              }
		},
		onLoadError:function(e){
		},
		onSelect: function (index, row) {
			GV.ADMID = row.admId;
			//refreshBar('',row.admId);
			//var admReaStr = getAdmReasonInfo(row.admId);
			//var admReaAry = admReaStr.split("^");
			//var admReaId = admReaAry[0];
			var INSUType = "00A";
			$("#QInsuType").combobox('select', INSUType);
			GetInsuAdmInfo();                 //获取医保就诊信息
			//QryDiagLst();                     //加载就诊诊断
			       
		}
	});
}
//获取医保就诊信息函数
function GetInsuAdmInfo()
{
	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		Paadm: GV.ADMID
	}, function (rtn) {
          if (typeof rtn != "string")
         {
	       //$.messager.alert('提示','没有在His找到医保登记(挂号)信息','info');
	     }
		if (rtn.split("!")[0] != "1") {
			//$.messager.alert('提示','没有在His找到医保登记(挂号)信息','info');
		} else {
			var myAry = rtn.split("!")[1].split("^");
			GV.INSUADMID =  myAry[0];
			setValueById("psnNo", myAry[2]);              //医保号
			setValueById("INSUCardNo", myAry[3]);         //医保卡号
            setValueById("insuOptins",myAry[8])              //医保统筹区
            setValueById("InsuType",myAry[36])              //医保统筹区
		}
	});
	
}
// 加载就诊列表
function loadAdmList(myPapmiId) {
	$('#AdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "web.INSUReport",
		QueryName: "FindAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		HisType:"O"
	}
	loadComboGridStore("AdmList", queryParams);
}
// 登记号回车事件
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}
//布局初始化
function init_layout(){	
	// east-panel
	var bodyWidth = +$('body div:first').css('width').split('px')[0];
	var westWidth = '800';
	var eastWidth = bodyWidth - westWidth;  	
	$('.west-panel').panel({ 
		width:westWidth 
	});  
	$('.west-panel').panel('resize');
	// east
	$('.east-panel').panel({
		width:eastWidth,
	});
	$('.east-panel').panel('resize');
	$('.layout-panel-east').css('left' ,westWidth + 'px'); 
	
	$('.EastSearch').panel({
		width:100	
	});
	$('.EastSearch').panel('resize');

	var dgHeight = 150; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - 查询面板
	var height = 200;
	$('#dg').datagrid('options').height = 300;
	$('#dg').datagrid('resize');
	$('#ReportPanel').panel('options').height = 300;
	$('#ReportPanel').panel('resize');
	
}
// 医保类型 和医保类型有关的 下拉框需要在这重新加载
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('QInsuType','DLLType',Options); 	
	$('#QInsuType').combobox({
		onSelect:function(){
			// 加载险种类别
			init_XZType();
			
		    // 加载就诊凭证类型
			init_CertType();
			
			// 加载生育类别
			init_MatnType();
			// 加载民族
			init_Naty();
			
			// 加载人员证件类型
			init_PsnCertType();
			init_tPsnCertType()
			// 加载生育待遇申报人类别
			init_MatnTrtDclaerType();
			
			// 加载代办人证件类型 
			init_agnterCertType();
			
			// 加载配偶证件类型 
			init_SpusCertType();
			
			// 加载代办人关系
			init_agnterRlts();
			
			// 加载默认定点机构名称、代码 upt 20220428 HanZH
			init_fixmedins();
			//加载备案标识
			init_ValiFlagSearch();
		}	
	})
		
}
// 加载默认定点机构名称、代码 add 20220428 HanZH
function init_fixmedins(){
	$.m({
			ClassName: "web.INSUDicDataCom",
			MethodName: "GetDicDataDescByCode",
			Type: 'HISPROPerty' + getValueById('QInsuType'),
			CodeStr: "InsuHospCode",
			HospDr: GV.HospDr
		}, function(DescStr) {
			if (!DescStr) {
				$.messager.popover({msg: "未查询到定点机构编码，请核实医保参数配置数据！", type: "info"});
				return;
			}
			setValueById('fixmedinscode',DescStr);       //定点机构编号
		});
	$.m({
			ClassName: "web.INSUDicDataCom",
			MethodName: "GetDicDataDescByCode",
			Type: 'HISPROPerty' + getValueById('QInsuType'),
			CodeStr: "InsuHospName",
			HospDr: GV.HospDr
		}, function(DescStr) {
			if (!DescStr) {
				$.messager.popover({msg: "未查询到定点机构名称，请核实医保参数配置数据！", type: "info"});
				return;
			}
			setValueById('fixmedinsname',DescStr);       //定点机构名称
		});
	
}
// 险种类别
function init_XZType(){
	$HUI.combobox(('#InsuType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'insutype' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#InsuType').combobox('select', "310");
		}		
	});

}
// 生育类别
function init_MatnType(){
	$HUI.combobox(('#MatnType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'matn_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
 			$('#MatnType').combobox('select', "1");
		}		
	});	
}

/*
 * 生育待遇申报人类别
 */
function init_MatnTrtDclaerType(){
	$HUI.combobox(('#MatnTrtDclaerType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'matn_trt_dclaer_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#MatnTrtDclaerType').combobox('select', "1");
		}		
	});
	
}

/*
 * 人员证件类型
 */
function init_PsnCertType(){
	$HUI.combobox(('#PsnCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
 			$('#PsnCertType').combobox('select', "01");
		}		
	});
	
}
function init_tPsnCertType(){
	$HUI.combobox(('#tPsnCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
 			$('#tPsnCertType').combobox('select', "01");
		}		
	});
	
}

/*
 * 代办人证件类型 
 */
function init_agnterCertType(){
	$HUI.combobox(('#AgnterCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#AgnterCertType').combobox('select', "01");
		}		
	});
}

/*
 * 配偶证件类型 
 */
function init_SpusCertType(){
	$HUI.combobox(('#SpusCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#SpusCertType').combobox('select', "01");
		}		
	});
}

/*
 * 代办人关系
 */
function init_agnterRlts(){
	$HUI.combobox(('#AgnterRlts'),{
		panelWidth:230,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'agnter_rlts' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
}

/*
 * 性别
 */
function init_Sex(){
	$HUI.combobox(('#Sex'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'gend' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}

/*
 * 民族
 */
function init_Naty(){
	$HUI.combobox(('#Naty'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'naty' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}

/*
 * 就诊凭证类型
 */
function init_CertType(){
	
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('CertType','mdtrt_cert_type'+getValueById('QInsuType') ,Options); 
	$('#CertType').combobox({   
       onLoadSuccess: function(){
            $('#CertType').combobox('select', "99");
        }
	});		
}

/*
 *查询面板医保类型
 */
function init_SearchInsuType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			// 加载备案标志
			init_ValiFlagSearch();
			// 加载查询面板证件类型 
			//init_CertTypeSearch();
			
		},	
		
	})
}

//查询面板备案标志
function init_ValiFlagSearch()
{
	$HUI.combobox('#SearchValiFlag', {
		panelHeight: 'auto',
		data: [{
				value: '1',
				text: '备案成功'
				
			},{
				value: '0',
				text: '备案失败'
			},{
				value: '',
				text: '全部',
				'selected':true
			}
		],
		valueField: 'value',
		textField: 'text',
	});
	
}
/*
 * 查询面板证件类型
 */
function init_CertTypeSearch(){
	$HUI.combobox(('#SearchType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#SearchType').combobox('select', "01");
		}		
	});
	
}

/*
 * datagrid
 */
function init_dg() {
	// 初始化DataGrid
	$('#dg').datagrid({
		data:[],
		fit:true,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		frozenColumns:[[
		    {field:'TRowid',title:'TRowid',width:100,hidden:true},
			{field:'TMatnType',title:'生育类别',width:100},
			{field:'TValiFlag',title:'有效标志',width:80,align:'center',styler:function(val, index, rowData){
				switch (val){
					case "被作废":
						return "color:red";
						break;
					case "有效":
						return "color:green";
						break;
					case "作废":
						return "color:yellow";
						break;
					case "待备案":
						return "color:blue";
						break;	
					case "备案失败":
						return "color:pink";
						break;			
				}
			}},	
			{field:'TPsnName',title:'人员姓名',width:100 }
			]],
		columns:[[ 
			{field:'THiType',title:'医保类型',width:100},
			{field:'TBegnDate',title:'开始日期',width:100},
			{field:'TEndDate',title:'结束日期',width:100},
			{field:'TPsnNo',title:'个人编号',width:120 },
			{field:'TPsnCertType',title:'证件类型',width:160 },
			{field:'TCertno',title:'证件号码',width:150 },
			{field:'TTel',title:'联系电话',width:100},
			{field:'TAddr',title:'联系地址',width:150 },
			{field:'TInsuOptins',title:'参保医保区划',width:150 },
			{field:'TFixmedinsCode',title:'定点机构编号',width:150 },
			{field:'TFixmedinsName',title:'定点机构名称',width:150 },
			{field:'TMemo',title:'备注',width:150 },
			{field:'TOpterId',title:'经办人',width:100 },
			{field:'TOptDate',title:'经办日期',width:100},
			{field:'TOptTime',title:'经办时间',hidden:true},
			{field:'TUpdtId',title:'更新人',hidden:true },
			{field:'TUpdtDate',title:'更新日期',hidden:true},
			{field:'TUpdtTime',title:'更新时间',hidden:true},
		    {field:'TRowid',hidden:true},
		    {field:'THospId',hidden:true},
		    {field:'TPapmiDr',hidden:true}, //基本信息表Dr
		    {field:'TAdmDr',hidden:true}, //就诊表Dr
		    //{field:'TInsuAdmInfoDr',hidden:true},
			//{field:'TDclaSouc',hidden:true}, //申报来源
			{field:'TInsutype',hidden:true} //险种类型
		]],
		toolbar: '#tToolBar',
		onDblClickRow:function(index,rowData){
			ModINSUTarItems();
		},
		onClickRow:function(index,rowData){
			
		}
	});
}

//修改赋值
function FillCenterInfo(i,rowDataObj){

	var MatnID=rowDataObj.TRowid;
	GV.MatnRowid=MatnID
	
	var MatnInfo=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetMatnTrtRegById",MatnID);
	var MatnArr=MatnInfo.split("^");
	GV.SelADMID=MatnArr[3];    //医生选择的就诊记录
	if(GV.SelADMID!=""){
		//disableById("AdmList"); 
	}
	setValueById("PsnCertType",MatnArr[6])	           //人员证件类型
	setValueById("Certno",MatnArr[7])	               //人员证件号码
	setValueById("name",MatnArr[8])	                   //姓名
	setValueById("BrDate",MatnArr[11])                 //出生日期
	setValueById("GesoVal",MatnArr[12])                //孕周数
	setValueById("MatnTrtDclaerType",MatnArr[13])      //生育申报人类别 
	setValueById("FpscNo",MatnArr[14])                 //计划生育服务号
	setValueById("LastMenaDate",MatnArr[15])           //末次月经时间           
	setValueById("PlanMatnDate",MatnArr[16])           //预计生育时间
	setValueById("SpusName",MatnArr[17])               //配偶姓名
	setValueById("SpusCertType",MatnArr[18])           //配偶证件类型
	setValueById("SpusCertNo",MatnArr[19])             //配偶证件号码	
	setValueById("SDate",MatnArr[22])                  //开始日期
	setValueById("EDate",MatnArr[23])                  //结束日期
	setValueById("tel",MatnArr[25])                    //联系电话
	setValueById("addr",MatnArr[26])                   //联系地址
	setValueById("Fetts",MatnArr[27])                  //胎次
	setValueById("AgnterName",MatnArr[44])             //代办人
	setValueById("AgnterCertType",MatnArr[45])         //代办人证件类型
	setValueById("AgnterCertno",MatnArr[46])           //代办人证件号码
	setValueById("AgnterTel",MatnArr[47])              //代办人联系方式
	setValueById("AgnterAddr",MatnArr[48])             //代办人联系地址
	setValueById("AgnterRlts",MatnArr[49])             //代办人关系
	setValueById("reflRea",MatnArr[50])                //备注
	
	setValueById("psnNo",MatnArr[5])                //人员编号  
	GV.InsuAdmDvs=MatnArr[29]                       //参保地编号
	
	GV.OpterId=MatnArr[51]                             //经办人Id
	GV.OpterDate=MatnArr[52]                             //经办日期
	GV.OpterTime=MatnArr[53]                             //经办时间              
}



/*
 * 加载数据
 */
function initLoadGrid(){
		
	var queryParams = {
		ClassName : 'INSU.MI.BL.MatnTrtRegCtl',
		QueryName:'QueryMatnTrtReg',
		StartDate : getValueById("StartDate"),
	    EndDate : getValueById("EndDate"),
	    HiType : "00A",
	    InsuNo : getValueById("SearchInsuNo"),
	    PsnName: getValueById('SearchName'),
	    PatType : getValueById('SearchType'),
	    PatId : getValueById('SearchId'),
	    HospId : GV.HospDr
	}
	loadDataGridStore('dg',queryParams);
	
}

/*
 * 查询医保审核信息
 */
$('#btnFindReport').bind('click', function () {
	FindReportInfo();
})

/*
 * 读医保卡
 */
$('#btn-readINSUCard').bind('click', function () {
	if(getValueById('QInsuType')==''){
		$.messager.alert('提示', "医保类型不能为空" + str, 'error');	
		return;	
	}
	var CardType="1",InsuNo="";
	CardType=getValueById('CertType');	
	
	//CardType=getValueById('certtype');
 	var IDCardNo=getValueById('IDCardNo');
 	if(IDCardNo==""){
	 	$.messager.alert('提示', "请填写孕妇的就诊凭证编号再获取人员信息" + str, 'error');
	 	return ;
	 	}
 	var tPsnCertType=getValueById('tPsnCertType');
 	var tPsnIDCardNo=getValueById('tPsnIDCardNo');
 	
	var ExpString = getValueById('QInsuType') + '^^' + GV.HospDr+"^^^"+CardType+"^"+IDCardNo+"^"+tPsnCertType+"^"+tPsnIDCardNo+"^^^";
	
	//var ExpString = getValueById('QInsuType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	
	/*var str = InsuReadCard('0',UserId,InsuNo,CardType,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('提示', "读卡失败" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	 
	 	setValueById('psnNo',TmpData1[0]);       //个人编号
	 	setValueById('INSUCardNo',TmpData1[1]);  //卡号
	 	setValueById('name',TmpData1[3]);        //姓名
	 	setValueById('Sex',TmpData1[4]);         //性别
	 	setValueById('Naty',TmpData1[5]);        //民族
	 	setValueById('BrDate',TmpData1[6]);      //出生日期
	 	setValueById('insuOptins',TmpData1[21]); //参保人所属地
	 	//setValueById('rylb',TmpData1[11]);     //人员类别	 
	 	setValueById('InsuType',TmpData[3]);       //险种类型	
	 
	 }*/
	 var IPAddress=getClientIP().split("^")[0];
	var MACAddress=getClientIP().split("^")[2];
	var Input=GV.USERID+"^"+GV.HospDr+"^"+IPAddress+"^"+MACAddress+"^1^7"+"^"+"02"+"^"+IDCardNo+"^"
	var str =tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetInsuPersonInfo",Input,"310","STR")
    var TmpData = str.split("^");
	if (TmpData[0]!="0"){
		$.messager.alert('提示', "获取人员信息失败" + str, 'error');	
		return;
	}else{
		//0^44020000001101143720|01|440222198312140019|张杰|1|99|1983-12-14|38.1$0|310|11|1|2010-10-01|null|0|440222|始兴县人民医院
		var TmpData1=TmpData[1];
		var TmpAry=TmpData1.split("$");
		var TmpPsnAry=TmpAry[0].split("|");
		var TmpInsuAry=TmpAry[1].split("|");
		setValueById('psnNo',TmpPsnAry[0]);       //个人编号
	 	//setValueById('INSUCardNo',TmpData1[1]);  //卡号
	 	setValueById('name',TmpPsnAry[3]);        //姓名
	 	setValueById('Sex',TmpPsnAry[4]);         //性别
	 	setValueById('Naty',TmpPsnAry[5]);        //民族
	 	setValueById('BrDate',TmpPsnAry[6]);      //出生日期	
	 	setValueById(GV.InsuAdmDvs,TmpInsuAry[7]); //参保人所属地
	 	setValueById('InsuType',TmpInsuAry[1]);    //险种类型	
		
		
	}
    
});
/**
* 数据校验
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#' + rowData.id).parent().prev().find('label').text();
			var clsStr = $('#' + rowData.id).attr('class');
			if(clsStr.indexOf('combobox') > 0){
				var vaildCheck = getValueById(rowData.id);
				if(vaildCheck ==''>0){
					$.messager.alert('提示', '[' + labelDesc +']' + '验证不通过' , 'error');
					throw rowData.id;
				}
			}else{
				$.messager.alert('提示', '[' + labelDesc +']' + '验证不通过' , 'error');
				throw rowData.id;
			}
		});		
	}
}

/*
 * 查询
 */
$('#btnFind').bind('click', function () {
	initLoadGrid();
});
/* 
 * 查询医保审核信息
 */
function FindReportInfo(){
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag =='已撤销'){
			$.messager.alert('提示', "审核已经撤销", 'info');
			return;
		}
		$.messager.alert('提示', "需要连接医保中心", 'info');	
	} else {
		$.messager.alert('提示', "请选择要查询的记录", 'info');
	}
}
 

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				return;
				//focusById("patientNo");
			}
			var admStr = "";
			setPatientInfo(papmi);
			loadAdmList(papmi);
			//refreshBar(papmi,'');
		});
	}
}

function setPatientInfo(papmi) {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCINSUPatInfo",
		MethodName: "GetPatInfoByPatID",
		PatID: papmi,
	}, function(rtn) {
		var myAry = rtn.split("!");
		if(myAry[0]!=1){
			 $.messager.alert('提示', "未找到该患者基本信息请核实", 'info');
			  return ;
			}
		 myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);
		setValueById("name", myAry[2]);
		setValueById("tel", myAry[6]);
		setValueById("addr", myAry[16]+myAry[18]+myAry[20]+myAry[7]);
		setValueById("Sex", myAry[4]);
		setValueById("IDCardNo", myAry[8]);
		setValueById("tPsnIDCardNo", myAry[8]);
		setValueById("Certno", myAry[8]);
		setValueById("BrDate", myAry[9]);
		
	});
}


/**
 * 刷新患者信息条
 */
 /*
function refreshBar(papmi, adm) {
	//loadAdmList(papmi);
	$.m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: adm,
		PatientID: papmi
	}, function (html) {
		if (html != "") {
			$(".PatInfoItem").html(reservedToHtml(html));
		} else {
			$(".PatInfoItem").html("获取患者信息失败，请检查【患者信息展示】配置。");
		}
	});
}*/


function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function (v) {
		return replacements[v];
	});
}

/**
* banner提示信息
*/
function showBannerTip() {
	$(".PatInfoItem").html("<div class='unman'></div><div class='tip-txt'>请先查询患者</div>");
}


function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//clear();
		var cardNo = getValueById("HISCardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	loadAdmList('');
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			//focusById("HISCardNo");
		});
		break;
	case "-201":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	default:
	}
	if (patientId != "") {
		var admStr = "";
		loadAdmList(patientId);
		refreshBar(patientId, '');
	}
}

/**
* 获取就诊费别信息
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}
// HIS收费项目
function init_HISTarItem(){		
	$('#xmbm').combobox({
		valueField: 'code',
		textField: 'desc',
		url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindTarItem&ResultSetType=array',
		mode: 'remote',
		method: 'get',
		onBeforeLoad: function (param) {
			if (!param.q) {
				return false;
			}
			$.extend(param, {
				code: "",                           //项目代码
				desc: "",                           //项目名称 根据输入数据查询
				alias: param.q,                     //别名
				str: '',                //入参串
				HospID: GV.HospDr    //医院ID
			});
			return true;
	 	}
	});
}
$('#btnClean').bind('click',function(){
	
	addINSUTarItems();
		
})
$('#btnReferMod').bind('click',function(){
	
	ModINSUTarItems();
		
})
$('#btn-readCard').bind('click',function(){
	//readHFMagCardClick();	
	readInsuCardClick();	
})

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}

function clear(){
	//查询区域
	$(".searchPanel").form("clear");
	$('#SearchInsuType').combobox('reload');
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
	//setValueById('SDate',getDefStDate(0));
	//setValueById('EDate',getDefStDate(1));
	//InsuDateDefault('SDate',-1);	//upt HanZH 20210918	
	//InsuDateDefault('EDate',365);
			
	//setValueById('RRefLtype',"");
	//$('#RRefLtype').combobox('reload');	
	//setValueById('StartDate',getDefStDate(0));
	//setValueById('EndDate',getDefStDate(1));
	//InsuDateDefault('StartDate',-1);	//upt HanZH 20210918
	//InsuDateDefault('EndDate');	
	
	//InsuDateDefault('DclaDate');
	initDate();
	initLoadGrid();
}

/*
*读医保卡
*/
function readInsuCardClick()
{ 
	var rtn="-1"
	var Info=""
	rtn=InsuReadCard(1,GV.USERID,"","","^^^^^^^^^^")
	if (rtn.spit("|")[0]!="0"){
		$.messager.popover({msg: "读医保卡失败", type: "info"});
		return;	
	}else{
		Info=rtn.spit("|")[1].split("^")
		setValueById("psnNo", Info[0]);
		setValueById("name", Info[3]);
		//setValueById("Sex", Info[4]);
		setValueById("insuOptins", Info[21]);
		setValueById("XZType", Info[27].split("|")[2]);
		setValueById("PoolareaNo", Info[21]);
		setValueById("BrDate", Info[6]);	//出生日期 add 20220429 HanZH 
		setValueById("PsnCertType", Info[25]);	//人员证件类型
		setValueById("Certno", Info[26]);	//人员证件号码 
	}
}


/*
 * 增加生育备案登记
 * 靳帅 2022/11/24
 */ 
function addINSUTarItems() { 
	var TRowid=""
    var InsuType= getValueById("QInsuType");

	if(getValueById("AdmList")==""){
		$.messager.alert("温馨提示","请选择就诊信息!", 'info'); 
		return;
	}
	if ("undefined"==typeof parent.window.HISUIStyleCode || parent.window.HISUIStyleCode==""){
		// 炫彩版
		var top="218.5px"
	    var left="245.5px"
	  
	  }else if (parent.window.HISUIStyleCode=="lite"){
		// 极简版
	    var top="177"
	    var left="267"
	 }else{
		// 炫彩版
	    var top="218.5px"
	    var left="245.5px"
	  }
	var url = "dhcinsu.matntrtregpop.csp?&Rowid="+GV.ADMID+"&HiType="+InsuType+"&HospId="+GV.HospDr+"&TRowid="+TRowid+"&patientNo="+getValueById("patientNo"); 		
	websys_showModal({
		url: url,
		title: "新增-生育备案登记",
		iconCls: "icon-w-add",
		width: "905",
		top:top,
		left: left,
		height: "448",
		onClose: function () {
			clear();
			//QryInOperList();
		}   
	});
	

}
/*
 * 修改生育备案登记
 * 靳帅 2022/12/02
 */	
	function ModINSUTarItems() {
	
	var selected = $('#dg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("温馨提示","请选择一条备案记录!", 'info');
	}
	else{
				var TRowid=selected.TRowid;
				if ("undefined"==typeof parent.window.HISUIStyleCode || parent.window.HISUIStyleCode==""){
					// 炫彩版
					var top="218.5px"
					var left="245.5px"
				  
				  }else if (parent.window.HISUIStyleCode=="lite"){
					// 极简版
					var top="177"
					var left="267"
				 }else{
					// 炫彩版
					var top="218.5px"
					var left="245.5px"
				  }	
	var url = "dhcinsu.matntrtregpop.csp?&Rowid="+GV.ADMID+"&HiType="+InsuType+"&HospId="+GV.HospDr+"&TRowid="+TRowid; 		
	websys_showModal({
		url: url,
		title: "修改-生育备案登记",
		iconCls: "icon-w-edit",
		width: "905",
		height: "448",
		top:top,
		left: left,
		onClose: function () {
			clear();
			//QryInOperList();
		}   
	});
		}
	
	}
/*
*初始化日期格式
*HanZH 20210918
*/
function init_Date(){
	InsuDateDefault('StartDate');
	InsuDateDefault('EndDate');
	InsuDateDefault('SDate');
	InsuDateDefault('EDate');
	InsuDateDefault('DclaDate');
	InsuDateDefault('LastMenaDate');
	InsuDateDefault('PlanMatnDate');
	}
function initDate(){
		
	var today=new Date();
	date=new Date(today.getTime()-24*60*60*1000);
	var s0=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+"01"
	
	 
	var s1=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+getSpanDays(date.getMonth()+1)
	
	$('#StartDate').datebox({
		value: s0,
	    formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
		}
	});
	
	$('#EndDate').datebox({
		value: s1,
		formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
			
		},
	});
	function getSpanDays(month,year){
		var SpanDays=31;
		if ((month == 4)||(month == 6)||(month == 9)||(month == 11)){
			 SpanDays=30;
			}
		if (month == 2) {
			var tyear=year||(new Date()).getFullYear();
			SpanDays=28;
			if((tyear%4 ==0)&&(tyear%100 !=0)){
				 SpanDays=29;
				}
			}
			
			return SpanDays ;
		
		}
}
