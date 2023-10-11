 /*
 * FileName:	dhcinsu/matntrtregpop.js
 * User:		JinS1010
 * Date:		2023-02-20
 * Function:	生育待遇备案(弹窗)
 */ 
// 定义常量
var Rq = INSUGetRequest();
var TRowid = Rq["TRowid"]
 var GV = {
	HospDr:session['LOGON.HOSPID'] ,  //院区ID
	USERID:session['LOGON.USERID'] ,  //操作员ID
	GROUPID:session['LOGON.GROUPID'], //安全组id
	ADMID:Rq["Rowid"],               //就诊ID
	SelADMID:'',                      //选择的就诊ID                   
	INSUADMID : '',                   //医保就诊信息ID
	MatnRowid:'',                     //生育备案表rowid
	fixmedinsCode:'H36011100214',     //定点医药机构编号(项目填自己的)
	fixmedinsName:'南昌市第九医院',   //定点医药机构名称(项目填自己的)
	PoolareaNo:'360100',              //医院所在统筹区编号(项目填自己的)
	InsuAdmDvs:'',                    //患者参保地编码 
	OpterId:'',                       //经办人                     
	OpterDate :'',                    //经办日期
	OpterTime :''                     //经办时间
} 

var index=1
//入口函数
$(function(){
	//设置页面布局
	setPageLayout();    
	//设置页面元素事件
	setElementEvent();	
	//加载初始信息
	getPatInfo();
	//设置关闭页面事件
	initEvent(); 
});
//设置页面布局
function setPageLayout(){
	
	// 医保类型
	init_INSUType();
	
	// 就诊记录
	initAdmList();
		
	//初始化生育待遇备案记录	
	init_dg();
    
    //初始化生育待遇备案记录	
    if(TRowid!="")
    {
	pop();
    }
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
}

/*
*新增或修改信息
*/
function MatnTrtMod_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	var Rowid=GV.MatnRowid;
	var PapmiDr="";                            //基本信息表Dr
	var HiType=getValueById('QInsuType');
	var InStr="",ExpStr="";
	var InStr=TRowid+"^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType; 
	setValueById('psnNo',index)
	//人员编号^人员证件类型^证件号码^人员姓名^民族^性别^出生日期^孕周数^生育待遇申报人类别^计划生育服务证号^末次月经日期^预计生育日期^ 5-16
	//配偶姓名^配偶证件类型^配偶证件号码^定点医药机构编号^定点医药机构名称^开始日期^结束日期^统筹区编号^联系电话^联系地址^胎次^生育类别^ 17-28
	//参保所属医保区划^险种类型^待遇申报明细流水号^有效标志^单位编号^单位名称^人员参保关系ID^经办机构编号^经办人姓名^门诊检查报销标准^ 29-38
	//生育资格登记状态^申报日期^字段扩展^扩展参数1^扩展参数2^代办人姓名^代办人证件类型^代办人证件号码^代办人联系方式^代办人联系地址^ 39-48
	//代办人关系^备注^经办人ID^经办日期^经办时间^更新人ID^更新日期^更新时间 49-56
	//^2^^^00A^测试^411481199910105177^^^^5^1^11^^^111^01^111^H44022200010^始兴县人民医院^2022-02-16^2022-12-07^440222^18137077186^111111^1^7
	//^^310^1^A^^^^H44022200010^^^A^2022-12-1^^^^111^01^111^11^^1^^^^^909^2022-12-1^14:36:1
	var psnNo=getValueById('psnNo');
	InStr=InStr+"^"+psnNo;                                       			//人员编号  医保登记表  INADM_InsuId
	
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
	var Sex=getValueById('Sex');                                            //性别
	InStr=InStr+"^"+Sex;                                 		             
	InStr=InStr+"^"+getValueById('Naty');                                 	//民族
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
	
	var InsuAdmdvs=GV.InsuAdmDvs                                          //参保所属医保区划 （undif）
	if(InsuAdmdvs===undefined){
		
		InsuAdmdvs=""
		}
	
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

	var today=new Date();
	var NowDate=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
	var NowTime=today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
	var UpdtId=UserId                                                          //更新人（备案人）-----医保办人员，不分人
	var UpdtDate=NowDate                                                        //更新日期
	var UpdtTime=NowTime                                                       //更新时间
	
	if(TRowid==""){                                             //-医保办人员，不分人
		
		OpterId=UpdtId
		OptDate=UpdtDate
		OptTime=UpdtTime
		}else{
		if (GV.OpterId!=""){OpterId=GV.OpterId}	
	      if (GV.OpterDate!=""){OptDate=GV.OpterDate}
	     if (GV.OpterTime!=""){OptTime=GV.OpterTime}                             //如果医师填写的，填写人不能变	
			}
		                                                                         //如果医师填写的，填写人不能变
	InStr=InStr+"^"+OpterId+"^"+OptDate+"^"+OptTime; 	
	InStr=InStr+"^"+UpdtId+"^"+UpdtDate+"^"+UpdtTime;
	console.log(InStr)
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
			    index=index+1
			   $.messager.alert('提示','修改生育备案数据成功');
			   initLoadGrid();	
			}
	  $.messager.progress("close");
	});	 
	initLoadGrid();	
}
/**
*初始化就诊记录
*/
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
/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
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
			
			//加载备案标识
			init_ValiFlagSearch();
		}	
	})
}
/*
 * 险种类别
 */
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
/*
 * 生育类别
 */
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
			//FindReportInfo();	
		},
		onClickRow:function(index,rowData){
			//选中待上传记录，将数据加载到左边备案界面
			GV.MatnRowid="";
			GV.SelADMID="";
			FillCenterInfo(index,rowData)
		}
	});
}
/*
 * 加载数据
 */
function initLoadGrid(){	
	var SearchValiFlag=getValueById("SearchValiFlag")
	var queryParams = {
		ClassName:'INSU.MI.BL.MatnTrtRegCtl',
		QueryName:'QueryMatnTrtReg',
		StartDate:getValueById("StartDate"),
	    EndDate:getValueById("EndDate"),
	    HiType:"00A",
	    InsuNo:getValueById("patientNo"),
	    PsnName:"",
	    PatType:getValueById('tPsnCertType'),
	    PatId:getValueById('tPsnIDCardNo'),
	    SearchValiFlag:SearchValiFlag,
	    HospId:GV.HospDr
	}
	loadDataGridStore('dg',queryParams);
}function FillCenterInfo(i,rowDataObj){
	if(rowDataObj.TValiFlag!="待备案" && rowDataObj.TValiFlag!="备案失败"){return;}
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
function getPatInfo() {

	var patientNo = Rq["patientNo"];
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
$('#btnClean').bind('click',function(){
	addINSUTarItems();
	clear();		
})
//清屏
function clear(){
	//查询区域
	$(".searchPanel").form("clear");
	$('#SearchInsuType').combobox('reload');
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
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
	var InsuType = getValueById('QInsuType');
	if(InsuType==""){
		$.messager.alert('提示','医保类型不能为空','info');
		return;	
	}
	var url = "dhcinsu.matntrtregpop.csp?&Rowid="+"&HiType="+InsuType+"&HospId="+GV.HospDr; 	
	websys_showModal({
		url: url,
		title: "新增-生育备案登记",
		iconCls: "icon-w-edit",
		width: "1200",
		height: "600",
		onClose: function () {
			clear();
			}   
	});
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
	InsuDateDefault('PlanMatnDate');	}
function pop(){
    var MatnID=TRowid
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
	setValueById("MatnType",MatnArr[28])               //生育类型
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
	setValueById("psnNo",MatnArr[5])                   //人员编号  
	GV.InsuAdmDvs=MatnArr[29]                          //参保地编号
	GV.OpterId=MatnArr[51]                             //经办人Id
	GV.OpterDate=MatnArr[52]                           //经办日期
	GV.OpterTime=MatnArr[53]                           //经办时间              
}
function initEvent(){
	$("#btnU").click(function () {	
  
		MatnTrtMod_Click();	
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
}
