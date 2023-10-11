/*
 * FileName:	sevspbigdisereg.js
 * User:		HanZH
 * Date:		2023-04-20
 * Function:	人员重特大疾病备案
 */
 
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,
	USERID:session['LOGON.USERID'] ,
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''

}
	
 $(function () { 
 
  $(document).keydown(function(e){
	 	banBackSpace(e);
	 	});
 	window.onresize=function(){
    	location.reload();//页面进行刷新
 	} 
	// 医保类型
	init_INSUType();
	
	// 查询面板医保类型
	init_SearchINSUType();
	
	// HIS卡类型
	initCardType();
	
	// 就诊记录
	initAdmList();

    //就诊诊断记录
	InitDiagLst();
	
	// 定点医院
	init_FixmedHosp();
	
	//click事件
	init_Click();
	
	//keydown事件
	init_keyDown();
	
	//初始化转院备案记录	
	init_dg(); 
	
	init_layout();
	
	//日期初始化
	//init_Date();
	
	//卡号回车查询事件
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	$("#HISCardType").combobox('disable',true);
	
	
	// 诊断名称		add HanZH 20230420
	$HUI.combobox(('#BydiseSetlDiseName'),{
		defaultFilter:'3',
		valueField: 'code',
		textField: 'desc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.DHCMRDiagnos';
			param.QueryName= 'LookUpWithAlias';
			param.desc = param.q;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		},
		onSelect:function(index,rowData){ 
			setValueById('BydiseSetlListCode',index.code);
		}		
	})
	// 手术操作名称		add HanZH 20230420
	$("#OprnOprtName").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'OprnOprtCode',
		textField: 'OprnOprtName',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'OprnOprtCode', title: '手术操作代码', width: 120},
			 {field: 'OprnOprtName', title: '手术操作名称', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("QInsuType") && ($.trim(param.q).length >= 1)) {
				$("#OprnOprtName").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "QueryOPRNOPRTLISTNEW";
				param.QryType="";
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.Desc = param.q;
				param.HospId=GV.HospDr;
				param.HiType = getValueById("QInsuType");
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.HisBatch="";
				param.Ver=""
			}else{
				$('#OprnOprtName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
				}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("OprnOprtCode", rowData.OprnOprtCode);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("OprnOprtCode", "");
			}
		}
	});
	clear();
});

/**
* 初始化卡类型
*/
function initCardType() {
	$HUI.combobox("#HISCardType", {
		url: $URL + "?ClassName=web.INSUReport&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "myTypeID",
		textField: "caption",
		onChange: function (newValue, oldValue) {
		},
		onLoadSuccess:function(){
			setValueById('HISCardType','');	
		}
	});
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
/**
*初始化click事件
*/		
function init_Click()
{
	  //备案登记
	  $("#btnRefer").click(SevSpBigDiseReg_Click);
      //备案撤销
      $("#btnReferDes").click(SevSpBigDiseRegDes_Click);  
       //备案查询
      $("#btnsearch").click(SevSpBigDiseRegsearch_Click); 
}
	
/**
*备案登记
*/	
function SevSpBigDiseReg_Click()
{
	var Handle=0
	var InStr=""   
	InStr=InStr+"^"+GV.HospDr;                                       		//##医院ID
	InStr=InStr+"^"+GV.PAPMI;                                       		//##基本信息表Dr
	InStr=InStr+"^"+GV.ADMID;                                       			//##就诊Dr
	                                                     
	//格式：医保类型^人员编号^人员证件类型^证件号码^人员姓名^民族^性别^出生日期^事件类型^申报来源^按病种结算病种目录代码^按病种结算病种名称^……5-16
	//手术操作代码^手术操作名称^定点医药机构编号^定点医药机构名称^医院级别^定点归属医保区划^开始日期^结束日期^……17-24
	//联系电话^联系地址^事件流水号^服务事项实例ID^服务事项环节实例ID^事件实例ID^待遇申报明细流水号^险种类型^有效标志^……25-34
	//单位编号^单位名称^人员类别^人员参保关系ID^参保所属医保区划^申请日期^申请理由^……35-41
	//代办人姓名^代办人证件类型^代办人证件号码^代办人联系方式^代办人联系地址^代办人关系^备注^字段扩展^……42-49
	//取消指针^经办人Id^经办日期^经办时间^更新人Id^更新日期^更新时间^取消指针……50-56
	//^数据库连接串
	var QInsuType=getValueById('QInsuType');
	if(QInsuType == "")
	{
		$.messager.alert("温馨提示","//医保类型不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+QInsuType;                                       		//医保类型
	
	var PsnNo=getValueById('PsnNo');
	if(PsnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+PsnNo;                                       			//人员编号
	InStr=InStr+"^"+"";                                       				//人员证件类型
	InStr=InStr+"^"+"";                                       				//证件号码
	InStr=InStr+"^"+"";                                       				//人员姓名
	InStr=InStr+"^"+"";                                       				//民族
	InStr=InStr+"^"+"";                                       				//性别
	InStr=InStr+"^"+"";                                       				//出生日期
	var EvtType=getValueById('EvtType');
	InStr=InStr+"^"+EvtType;												//事件类型
	var Dclasouc=getValueById('Dclasouc');
	InStr=InStr+"^"+Dclasouc;												//申报来源
	
	var BydiseSetlListCode=getValueById('BydiseSetlListCode');
	if(BydiseSetlListCode == "")
	{
		$.messager.alert("温馨提示","按病种结算病种目录代码不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+BydiseSetlListCode;										//按病种结算病种目录代码
	
	var BydiseSetlDiseName=getValueById('BydiseSetlDiseName');
	InStr=InStr+"^"+BydiseSetlDiseName;										//按病种结算病种名称
	var OprnOprtCode=getValueById('OprnOprtCode');
	InStr=InStr+"^"+OprnOprtCode;											//手术操作代码
	var OprnOprtName=getValueById('OprnOprtName');
	InStr=InStr+"^"+OprnOprtName;											//手术操作名称
	// var FixmedinsCode=getValueById('FixmedinsCode');
	// if(FixmedinsCode == "")
	// {
	// 	$.messager.alert("温馨提示","定点医药机构不能为空!", 'info');
	// 	return ;
	// } 
	FixmedinsCode=tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd","HISPROPerty"+QInsuType,"InsuHospCode",4,GV.HospDr)
	InStr=InStr+"^"+FixmedinsCode;											//定点医药机构编号
	//var FixmedinsName=getValueById('FixmedinsName');
	InStr=InStr+"^"+"";														//定点医药机构名称
	InStr=InStr+"^"+"";														//医院级别
	InStr=InStr+"^"+"";														//定点归属医保区划
	var SDate=getValueById('SDate');
	if(SDate == "")
	{
		$.messager.alert("温馨提示","开始日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+SDate;                                        			//开始日期
	var EDate=getValueById('EDate');
	InStr=InStr+"^"+EDate;                                        			//结束日期
	InStr=InStr+"^"+"";                                  					//联系电话
	InStr=InStr+"^"+"";                                 					//联系地址
	InStr=InStr+"^"+"";                                 					//事件流水号
	InStr=InStr+"^"+"";                                 					//服务事项实例ID
	InStr=InStr+"^"+"";                                 					//服务事项环节实例ID
	InStr=InStr+"^"+"";                                 					//事件实例ID
	InStr=InStr+"^"+"";                                 					//待遇申报明细流水号
	InStr=InStr+"^"+"";                                 					//险种类型
	InStr=InStr+"^"+"D";                                 					//有效标志
	InStr=InStr+"^"+"0";                                 					//审核状态
	InStr=InStr+"^"+"";                                						//单位编号
	InStr=InStr+"^"+"";                                						//单位名称
	InStr=InStr+"^"+"";                                						//人员类别
	InStr=InStr+"^"+"";                                						//人员参保关系ID
	InStr=InStr+"^"+"";                                						//参保所属医保区划
	var AppyDate=getValueById('AppyDate');
	InStr=InStr+"^"+AppyDate;                                               //申请日期
	var AppyRea=getValueById('AppyRea');
	InStr=InStr+"^"+AppyRea;                                               	//申请理由
	InStr=InStr+"^"+getValueById('AgnterName');                           	//代办人姓名
	InStr=InStr+"^"+getValueById('AgnterCertType');                       	//代办人证件类型
	InStr=InStr+"^"+getValueById('AgnterCertno');                         	//代办人证件号码
	InStr=InStr+"^"+getValueById('AgnterTel');                            	//代办人联系方式
	InStr=InStr+"^"+getValueById('AgnterAddr');                           	//代办人联系地址
	InStr=InStr+"^"+getValueById('AgnterRlts');                           	//代办人关系
	InStr=InStr+"^"+getValueById('Memo');                              		//备注
	InStr=InStr+"^"+getValueById('ExpContent');                             //字段扩展
	InStr=InStr+"^^^"+GV.USERID+"^^^"+GV.USERID+"^^^^^^";
	
	$m({
		ClassName:"INSU.MI.BL.SevSpBigDiseRegCtl",
		MethodName:"InsertSevSpBigDiseReg",
		InString:InStr,
	},function(Rtn){
		if(Rtn.split("!")[0]<0){
			$.messager.alert('提示',"人员重特大疾病备案数据保存失败："+Rtn);
		}else{
			var ExpStr=getValueById('QInsuType')+"^";
			var SevSpBigDiseRegDr=Rtn
			var rtn=INSUSevSpBigDiseReg(Handle,GV.USERID,GV.ADMID,SevSpBigDiseRegDr,ExpStr); //DHCINSUPort.js
			
			if (rtn!="0") 
			{
				$.messager.alert("提示","人员重特大疾病备案登记失败!Rtn="+Rtn, 'error');
				return ;
			}else{
				$.messager.alert('提示','人员重特大疾病备案登记成功');
				return ;
			}
		}
	  $.messager.progress("close");
	});
}
			
/**
*备案撤销
*/

function SevSpBigDiseRegDes_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected.TValiFlag!="有效"){
		$.messager.alert("提示","不是有效的备案记录不可撤销!", 'error');
		return 
	}
	// if (selected.TRchkFlag!="审核通过"){
	// 	$.messager.alert("提示","不是审核通过的备案记录不需撤销!", 'error');
	// 	return 
	// }
	if (selected) {
		if (selected.TRowid != "") {
			$.messager.confirm('确认', '确认撤销备案记录？', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr
    				var ExpString=getValueById('SearchInsuType')+"^"+selected.TRowid+"^" //格式:医保类型^重特大疾病登记表Rowid^数据库连接串
					var rtn=INSUSevSpBigDiseRegDestory(Handle, UserId,AdmDr,selected.TPsnNo,ExpString); //DHCINSUPort.js
					if (rtn!="0") 
	 				{
						$.messager.alert("提示","人员重特大疾病备案撤销失败!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("提示","人员重特大疾病备案撤销成功!", 'info',function(){
							initLoadGrid();	
						});
					}
				}
			});
		}
	}
	else{
			$.messager.alert('提示', "请选择要撤销的记录", 'info');		
			return false;
		}
}
function SevSpBigDiseRegsearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //格式:^^^数据库连接串
			var rtn=INSUSevSpBigDiseRegQuery(Handle,UserId,selected.TRowid,selected.THiType,ExpString); //DHCINSUPort.js
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

/**
*初始化keydown
*/
function init_keyDown()
{
	
	//患者查询
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
	//姓名回车查询事件
	$("#SearchName").keydown(function (e) {
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
}

/**
*初始化定点医院
*/
function init_FixmedHosp(){
	
    var data={total:0,rows:[]};
	$('#FixmedinsName').combogrid({
    panelWidth:450,
    value:'006',
    idField:'fixmedins_code',
    textField:'fixmedins_name',
    delay: 600,
	mode: 'remote',
	method: 'GET',
	pagination: true,
    columns:[[
        {field:'fixmedins_code',title:'医院代码',width:160},
        {field:'fixmedins_name',title:'医院名称',width:270}
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
				  ///$("#FixmedinsName").combogrid("grid").datagrid({data:data});   //有些老项目会导致 请求死循环 
				   $("#FixmedinsName").combogrid("grid").datagrid("loadData",data);  //DingSH 20220322 
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
					 $("#FixmedinsName").combogrid("grid").datagrid({data:newData});
			    }
			}else{
				$('#FixmedinsName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('FixmedinsCode',row.fixmedins_code);
			setValueById('HospLv',row.hosp_lv);
		}
});
}



function ReferHosp(){
	$("#reflinMedinsName").lookup("grid").datagrid({data:data})
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
		pageSize: 100,
		pageList: [100],
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
			refreshBar('',row.admId);
			var admReaStr = getAdmReasonInfo(row.admId);
			var admReaAry = admReaStr.split("^");
			var admReaId = admReaAry[0];
			var INSUType = GetInsuTypeCode(admReaId);
			$("#QInsuType").combobox('select', INSUType);
			GetInsuAdmInfo();
		 	QryDiagLst();                     //加载就诊诊断	
		 	GetReferDiseCondDscr();           //获取病情描述          
		}
	});
}

/**
*初始化就诊诊断记录
*/
function InitDiagLst()
{
	
	$('#DiagLst').combogrid({    
	    panelWidth:780, 
	    method:'GET',
	    idField:'DiagnosICDCode',  
	    textField:'DiagnosDesc' ,  
	    columns:[[    
	        {field:'DiagnosICDCode',title:'诊断编码',width:100},   
	        {field:'DiagnosDesc',title:'诊断名称',width:160}, 
	        {field:'DiagnosMRDesc',title:'诊断注释',width:80},  
	         {field:'MainDiagFlag',title:'主诊断',width:60,
	            formatter: function(value,row,index)
	                {
			              return  value=="Y" ? "是":"否" 
			        }
			   },    
	        {field:'DiagnosType',title:'诊断类型',width:80},   
	        {field:'DiagStat',title:'诊断状态',width:80},   
	        {field:'InsuDiagCode',title:'医保诊断编码',width:110},  
	        {field:'InsuDiagDesc',title:'医保诊断描述',width:150} 
	    ]] ,
		onClickRow:function(rowIndex, rowData)
		{
			  var DiagLstVal=rowData.DiagnosICDCode+"/"+rowData.DiagnosDesc+"/"+rowData.DiagnosMRDesc+"/"+rowData.DiagStat+"/"+rowData.InsuDiagCode+"/"+rowData.InsuDiagDesc;
		      $('#DiagLst').combogrid("setValue",DiagLstVal);
			  setValueById('diagCode',rowData.DiagnosICDCode);
			  setValueById('diagName',rowData.DiagnosDesc)
		}
       
  });  

}
/**
*查询就诊诊断记录
*/
function QryDiagLst()

{   
	//alert("GV.ADMID="+GV.ADMID)
	
	if (!!GV.ADMID)
    {
	    //alert("GV.ADMID="+GV.ADMID)
	 	var tURL=$URL+"?ClassName="+'web.DHCINSUPortUse'+"&MethodName="+"GetPatAllDiagsByADM"+"&PAADM="+GV.ADMID+"&DiagType="+""+"&ExpStr=^^HUIToJson" 
	 	//alert(tURL)
     	$('#DiagLst').combogrid({url:tURL});
    }
   
}


/**
*获取医保就诊信息函数
*/
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
		}
	});
	
}
// 加载就诊列表
function loadAdmList(myPapmiId) {
	GV.PAPMI=myPapmiId;
	$('#AdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "web.INSUReport",
		QueryName: "FindAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		HisType:"I"
	}
	loadComboGridStore("AdmList", queryParams);
}
/**
* 登记号回车事件
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}
/**
* 布局初始化
*/
function init_layout(){	
	// east-panel
	var bodyWidth = +$('body div:first').css('width').split('px')[0];
	var westWidth = '900';
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

	var dgHeight = window.document.body.offsetHeight - 36 - 20 - 12 - 122; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - 查询面板
	var height = dgHeight + 124 -135;
	$('#dg').datagrid('options').height = dgHeight;
	$('#dg').datagrid('resize');
	$('#ReportPanel').panel('options').height = height;
	$('#ReportPanel').panel('resize');
	
}
/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('QInsuType','DLLType',Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
	$('#QInsuType').combobox({
		onSelect:function(){
			// 加载申报来源
			init_Dclasouc();
			// 加载代办人证件类型
			init_AgnterCertType();
			// 加载代办人关系
			init_AgnterRlts();
			// 加载事件类型
			init_EvtType();
		}	
	})	
	
}

function init_SearchINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			//init_SearchType();
		}	
	})
}

/*
 * 初始化DataGrid
 */
function init_dg() {
	grid=$('#dg').datagrid({
		border: false,
		fit:true,
		striped:true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		border:false,
		autoSizeColumn:false,
		cache:true,
		pagination:true,
		rownumbers: false,
		toolbar: '#tToolBar',
		frozenColumns:[[
			{field:'TRowid',title:'登记ID',width:60 },
			{field:'TValiFlag',title:'有效标志',width:65,styler:function(val, index, rowData){
				switch (val){
					case "未备案":
						return "color:blue";
						break;
					case "被作废":
						return "color:red";
						break;
					case "有效":
						return "color:green";
						break;
					case "作废":
						return "color:red";
						break;			
				}
			}},
			{field:'TRchkFlag',title:'审核状态',width:70,styler:function(val, index, rowData){
				switch (val){
					case "未审核":
						return "color:blue";
						break;
					case "审核通过":
						return "color:green";
						break;
					case "审核不通过":
						return "color:red";
						break;
					case "已撤销":
						return "color:red";
						break;			
				}
			}},
			{field:'TPsnName',title:'人员姓名',width:80},
			{field:'TPsnCertType',title:'人员证件类型',width:120,hidden:true},
			{field:'TCertno',title:'证件号码',width:200,hidden:true}
			]],
		columns:[[ 
			{field:'TPsnNo',title:'人员编号',width:220},
			{field:'TPsnType',title:'人员类别',width:80},
			{field:'TServMattInstId',title:'服务事项实例ID',width:210},
			{field:'TTrtDclaDetlSn',title:'待遇申报明细流水号',width:260 },
			{field:'THospId',title:'医院ID',width:80,hidden:true},
			{field:'THiType',title:'医保类型',width:80,hidden:true},
			{field:'THiTypeDesc',title:'医保类型',width:80},
			{field:'TBydiseSetlListCode',title:'按病种结算病种目录代码',width:170},
			{field:'TBydiseSetlDiseName',title:'按病种结算病种名称',width:150},
			{field:'TOprnOprtCode',title:'手术操作代码',width:120},
			{field:'TOprnOprtName',title:'手术操作名称',width:120},
			{field:'TInsutype',title:'险种类型',width:120},
			{field:'TEvtType',title:'事件类型',width:80},
			{field:'TDclaSouc',title:'申报来源',width:80,hidden:true},
			{field:'TDclaSoucDesc',title:'申报来源',width:80},
			{field:'TBegnDate',title:'开始日期',width:90},
			{field:'TEndDate',title:'结束日期',width:90},
			{field:'TAppyDate',title:'申请日期',width:90},
			{field:'TEvtsn',title:'事件流水号',width:270},
			{field:'TServMattNodeInstId',title:'服务事项环节实例ID',width:230},
			{field:'TEvtInstId',title:'事件实例ID',width:230},
			{field:'TFixmedinsCode',title:'定点医药机构编号',width:100,hidden:true},
			{field:'TFixmedinsName',title:'定点医药机构名称',width:100,hidden:true},
			{field:'THospLv',title:'医院级别',width:100,hidden:true},
			{field:'TFixBlngAdmdvs',title:'定点归属医保区划',width:100,hidden:true},
			{field:'TOpterId',title:'经办人',width:80},
			{field:'TOptDate',title:'经办日期',width:90},
			{field:'TOptTime',title:'经办时间',width:80 },
			{field:'TUpdtId',title:'更新人Id',width:80},
			{field:'TUpdtDate',title:'更新日期',width:90},
			{field:'TUpdtTime',title:'更新时间',width:80},
			{field:'TPsnInsuRltsId',title:'人员参保关系ID',width:70,hidden:true},
			{field:'TGend',title:'性别',width:70,hidden:true},
			{field:'TNaty',title:'民族',width:75,hidden:true},
			{field:'TBrdy',title:'出生日期',width:90,hidden:true},
			{field:'TTel',title:'联系电话',width:100},
			{field:'TAddr',title:'联系地址',width:150},
			{field:'TInsuAdmdvs',title:'参保所属医保区划',width:130},
			{field:'TMsgId',title:'发送方交易流水号',width:150},
			{field:'TAdmDr',title:'就诊Dr',width:80},
			{field:'TMdtrtId',title:'就诊ID',width:80},		
			{field:'TEmpNo',title:'单位编号',width:180},
			{field:'TEmpName',title:'单位名称',width:130},
			{field:'TAgnterName',title:'联系地址',width:150},
			{field:'TMdtrtId',title:'代办人姓名',width:100},
			{field:'TAgnterCertType',title:'代办人证件类型',width:120},
			{field:'TAgnterCertno',title:'代办人证件号码',width:150 },
			{field:'TAgnterTel',title:'代办人联系方式',width:120 },
			{field:'TAgnterAddr',title:'代办人联系地址',width:150},
			{field:'TAgnterRlts',title:'代办人关系',width:100},
			{field:'TAppyRea',title:'申请理由',width:180},
			{field:'TMemo',title:'备注',width:180},
			{field:'TExpContent',title:'字段扩展',width:180}
		]],
        onSelect : function(rowIndex, rowData) {
        },
        onUnselect: function(rowIndex, rowData) {
        },
        onBeforeLoad:function(param){
	    },
	    onLoadSuccess:function(data){
			
		}
	});
}
/*
 * 加载数据
 */
function initLoadGrid(){
	if(getValueById('SearchInsuType')==''){
		//$.messager.alert('提示','医保类型不能为空','info');
		//return;	
	}
	var queryParams = {
	    
	    ClassName : 'INSU.MI.BL.SevSpBigDiseRegCtl',
	    QueryName : 'QuerySevSpBigDiseReg',
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HiType: getValueById('SearchInsuType'),
	    InsuNo: getValueById('SearchInsuNo'),
	    PsnName: getValueById('SearchName'),
	    PatType : getValueById('SearchType'),
	    PatId : getValueById('SearchId'),
	    HospId: GV.HospDr
	    
	}	
    loadDataGridStore('dg',queryParams);
	
}

function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
/*
 * 查询医保审核信息
 */
$('#btnFindReport').bind('click', function () {
	FindReportInfo();
})
/*
 * readcard
 */
$('#btn-readINSUCard').bind('click', function () {
	if(getValueById('QInsuType')==''){
		$.messager.alert('提示', "医保类型不能为空" + str, 'error');	
		return;	
	}
	var CardType="1",InsuNo="";
	CardType=getValueById('certtype');	
	var ExpString = getValueById('QInsuType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	var str = InsuReadCard('0',UserId,InsuNo,CardType,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('提示', "读卡失败" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	setValueById('psnNo',TmpData1[0]);       //个人编号
	 	//setValueById('INSUCardNo',TmpData1[1]);  //卡号
	 	//setValueById('name',TmpData1[3]);        //姓名
	 	//setValueById('Sex',TmpData1[4]);         //性别
	 	//setValueById('Naty',TmpData1[5]);        //民族
	 	//setValueById('BrDate',TmpData1[6]);      //出生日期
	 	//setValueById('insuOptins',TmpData1[21]); //参保人所属地
	 	//setValueById('rylb',TmpData1[11]);     //人员类别	 
	 	//setValueById('XZType',TmpData[3]);       //险种类型	
	 	//setValueById('BrDate',TmpData[6]);       //出生日期	
	 	//setValueById('EmpName',TmpData[8]);      //单位名称	
	 	//setValueById('EmpNo',TmpData[8]);        //单位编号	
	 	
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
			}
			var admStr = "";
			setPatientInfo(papmi);
			loadAdmList(papmi);
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
		//setValueById("name", myAry[2]);
		//setValueById("tel", myAry[6]);
		//setValueById("addr", myAry[16]+myAry[18]+myAry[20]+myAry[7]);
		//setValueById("Sex", 2);
		//setValueById("IDCardNo", myAry[8]);
		//setValueById("EmpName", myAry[7]);
	});
}


/**
 * 刷新患者信息条
 */
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
}


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
/**
* 初始化卡类型
*/
function initCardType() {
	$HUI.combobox("#HISCardType", {
		url: $URL + "?ClassName=web.INSUReport&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "myTypeID",
		textField: "caption",
		onChange: function (newValue, oldValue) {
		},
		onLoadSuccess:function(){
			setValueById('HISCardType','');	
		}
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

/**
* 获取就诊费别信息
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}

$('#btnClean').bind('click',function(){
	clear();		
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
	//initLoadGrid();
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
	InsuDateDefault('SDate',-1);	
	InsuDateDefault('EDate');
	InsuDateDefault('StartDate',-1);
	InsuDateDefault('EndDate');	
	InsuDateDefault('AdmTime');	
	InsuDateDefault('AppyDate');
	setValueById("AdmTime","");
	ClearGrid('dg');
	//清除combogrid下拉框里面的数据 addby LuJH 20230412
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", { 
		total: 0,
		rows: []
	});
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
	}
}

/*
*根据就这样获取病情信息
*DingSH 20210105
*/
function GetReferDiseCondDscr()
{
	if (!!GV.ADMID) {
		$.m({
			ClassName: "web.DHCINSUReferralInfoCtl",
			MethodName: "GetReferDiseCondDscr",
			AdmDr: GV.ADMID
		}, function(rtn) {
			setValueById("diseCondDscr", rtn);
		});
	}
}
	
/*
*初始化申报来源
*/
function init_Dclasouc(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('Dclasouc','dcla_souc' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
}

/*
 * 代办人关系
 */
function init_AgnterRlts(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('AgnterRlts','agnter_rlts' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js		
}

/*
 * 代办人证件类型
 */
function init_AgnterCertType(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('AgnterCertType','psn_cert_type' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
}

/*
 * 事件类型
 */
function init_EvtType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('EvtType','evt_type' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
}
