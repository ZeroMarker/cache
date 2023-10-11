/*
 * FileName:	dhcinsu.insureferral.js
 * User:		DingSH
 * Date:		2020-12-23
 * Description: 医保转院(转诊)备案
 */
 
 
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,
	USERID:session['LOGON.USERID'] ,
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''

}

 var TransactionNumber=2501;  //靳帅新增全局变量,交易代码 
 var ParentNodeCode="refmedin";//靳帅新增全局变量,父节点代码
 var ParameterCode="dise_cond_dscr";//靳帅新增全局变量,参数代码
 var FromtText="" //截取后的病情描述
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
	
	// 险种类别
	init_XZType();
	
	//转院类别
	init_RefLtype();
	
	// HIS卡类型
	initCardType();
	
	// 转诊医院
	init_ReferHosp();
	
	// 就诊记录
	initAdmList();

    //就诊诊断记录
	InitDiagLst();
	
	//click事件
	init_Click();
	
	//keydown事件
	init_keyDown();
	
	//初始化转院备案记录	
	init_dg(); 
	
	//init_layout();
	
	//日期初始化	add hanzh 20210918
	init_Date();
	
	$('#HISCardType').combobox('disable',true);
	
	//诊断初始化	add HanZH 20210918
	init_diag();
	
	//转院类型
	init_RRefLtype();
	
	clear();
	
});

/**
*初始化click事件
*/		
function init_Click()
{
	  //备案登记
	  $("#btnRefer").click(Refer_Click);
      //备案撤销
      $("#btnReferDes").click(ReferDes_Click);  
       //备案查询
      $("#btnsearch").click(Refersearch_Click);
      //转院备案记录导出   WangXQ 20220627
      $("#btnexport").click(Referexport_Click);
}
	
/**
*备案登记
*/	
function Refer_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID;
	


//st	upt HanZH 20210918
//	if(AdmDr == "")
//	{
//		$.messager.alert("温馨提示","请选择一条就诊记录", 'info');
//		return ;
//	}
//ed
	var ExpStr=""                                                        //格式：联系电话^地址^医院同意转院标志^转院类型^转院日期^转院原因^转院意见^开始日期^结束日期^类型^转往医院名字模糊搜索^转往医院编码^病情描述^数据库连接串
	
	var telNo=getValueById('tel');
	if(telNo == "")
	{
		$.messager.alert("温馨提示","联系电话不能为空!", 'info');
		return ;
	}
	ExpStr=telNo;                                                       //联系电话
	
	var addr=getValueById('addr');
	if(addr == "")
	{
		$.messager.alert("温馨提示","联系地址不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+addr;                                             //联系地址
	
	var hospAgreReflFlag=getValueById('hospAgreReflFlag');
	if(hospAgreReflFlag == "")
	{
		$.messager.alert("温馨提示","医院意见不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+hospAgreReflFlag;                                 //医院意见
	
	var refLtype=getValueById('refLtype');
	if(refLtype == "")
	{
		$.messager.alert("温馨提示","转诊类型不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+refLtype;                                        //转诊类型
	
	//var reflDate=GetInsuDateFormat(getValueById('reflDate'));
	var reflDate=getValueById('reflDate');	//upt HanZH 20210918
	
	if(reflDate == "")
	{
		$.messager.alert("温馨提示","转院日期不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+reflDate;                                        //转院日期
	
	//var reflRea=GetInsuDateFormat(getValueById('reflRea'));
	var reflRea=getValueById('reflRea');	//upt HanZH 20210918
	if(reflRea == "")
	{
		$.messager.alert("温馨提示","转院原因不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+reflRea;                                        //转院原因
	
	var reflOpnn=getValueById('reflOpnn');
	if(reflOpnn == "")
	{
		$.messager.alert("温馨提示","转院意见不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+reflOpnn;                                      //转院意见
	
	//var SDate=GetInsuDateFormat(getValueById('SDate'));
	var SDate=getValueById('SDate');	//upt HanZH 20210918
	if(SDate == "")
	{
		$.messager.alert("温馨提示","开始日期不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+SDate;                                        //开始日期
	
	//var EDate=GetInsuDateFormat(getValueById('EDate'));
	var EDate=getValueById('EDate');	//upt HanZH 20210918
	if(EDate == "")
	{
		$.messager.alert("温馨提示","结束日期不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+EDate;                                        //结束日期
	
	var fixmedinsType=1;
	ExpStr=ExpStr+"^"+fixmedinsType;                                //定点机构类型:医院或药店 
	
	var reflinMedinsName=getValueById('reflinMedinsName');          //转往医院
	var reflinMedinsNo=getValueById('reflinMedinsNo');              //转往医院编码
	
	
	if((reflinMedinsName == "") &&(reflinMedinsNo=="")) 
	{
		$.messager.alert("温馨提示","【转往医院】或者【转往医院编码】不能同时为空!", 'info');
		return ;
	}
	
	
	ExpStr=ExpStr+"^"+reflinMedinsName;                             
	
	
	
	ExpStr=ExpStr+"^"+reflinMedinsNo;   
	
	var diseCondDscr=getValueById('diseCondDscr');
	if(diseCondDscr == "")
	{
		$.messager.alert("温馨提示","病情描述不能为空!", 'info');
		return ;
	}
	
	FromtLength()                //控制病情描述长度，2022/10/15靳帅1010

	ExpStr=ExpStr+"^"+FromtText;                                //病情描述
	
	var connURL=""
	ExpStr=ExpStr+"^"+connURL;                                     //数据库连接串
	
	var psnNo=getValueById('psnNo');
	if(psnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+psnNo;                                       //人员编号
	
	var insuOptins=getValueById('insuOptins');
	if(insuOptins == "")
	{
		$.messager.alert("温馨提示","参保地不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+insuOptins;                                   //统筹区编号
	
	
	var XZType=getValueById('XZType');
	if(XZType == "")
	{
		$.messager.alert("温馨提示","险种类型不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+XZType;                                       //险种类型
	
	var diagCode=getValueById('diagCode');
	if(diagCode == "")
	{
		$.messager.alert("温馨提示","诊断代码不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+diagCode;                                      //诊断代码
	
	var diagName=getValueById('diagName');
	if(diagName == "")
	{
		$.messager.alert("温馨提示","诊断名称不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+diagName;                                       //诊断名称
	
	var mdtrtareaAdmdvs=getValueById('mdtrtareaAdmdvs');
	if(mdtrtareaAdmdvs == "")
	{
		mdtrtareaAdmdvs="000000"
	}
	ExpStr=ExpStr+"^"+mdtrtareaAdmdvs;                                       //就医地
	
	//alert(diagName)
	//return ;
	//联系电话^地址^医院同意转院标志^转院类型^转院日期^转院原因^转院意见^开始日期^结束日期^类型^
	//转往医院名字模糊搜索^转往医院编码^病情描述^数据库连接串^个人编号^统筹区号^险种类型^诊断代码^诊断名称 
	
	var rtn=INSUTransferHosApprove( Handle,UserId,AdmDr,getValueById('QInsuType'),ExpStr ); //DHCINSUPort.js
	if (rtn!="0") 
	 {
		$.messager.alert("提示","转院备案登记失败!rtn="+rtn, 'error');
		return ;
	}
	
	$.messager.alert("提示","转院备案登记成功!", 'info');
}
			
/**
*备案撤销
*/

function ReferDes_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			
			$.messager.confirm('确认', '确认撤销备案记录？', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr
					if(AdmDr == "")
					{
						$.messager.alert("温馨提示","请选择一条就诊记录", 'info');
						return ;
					}
    
    				var ExpString="^^需要重新备案" //格式:^^^数据库连接串
					var rtn=INSUTransferHosApproveDestory(Handle, UserId , AdmDr ,getValueById('QInsuType'), ExpString); //DHCINSUPort.js
					if (rtn!="0") 
	 				{
						$.messager.alert("提示","转诊备案撤销失败!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("提示","转诊备案撤销成功!", 'info',function(){
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
function Refersearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //格式:^^^数据库连接串
			var rtn=InsuTransferHospQuery(Handle,UserId,selected.TRowid,getValueById('QInsuType'),ExpString); //DHCINSUPort.js
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
	
	
	//卡号回车查询事件
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	//审批编号回车查询事件
	$("#SearchRPTNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//人员编号回车查询事件
	$("#SearchPatNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
}

/**
*初始化转诊院区
*/
function init_ReferHosp(){
	
    var data={total:0,rows:[]};
	$('#reflinMedinsName').combogrid({
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
				  ///$("#reflinMedinsName").combogrid("grid").datagrid({data:data});   //有些老项目会导致 请求死循环 
				   $("#reflinMedinsName").combogrid("grid").datagrid("loadData",data);  //DingSH 20220322 
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
					   $("#reflinMedinsName").combogrid("grid").datagrid("loadData",newData);
					 //return false;
			    }
			}else{
				$('#reflinMedinsName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('reflinMedinsNo',row.fixmedins_code);
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
			//refreshBar('',row.admId);
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
	         {field:'MainDiagFlag',title:'主诊断',width:60,align:'center',
	            formatter: function(value,row,index)
	                {
			              return  value=="Y" ? "是":"否" 
			        }
			   },    
	        {field:'DiagnosType',title:'诊断类型',width:80,align:'center'},   
	        {field:'DiagStat',title:'诊断状态',width:80,align:'center'},   
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

	//var dgHeight = window.document.body.offsetHeight - 36 - 20 - 12 - 100; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - 查询面板
	//var height = dgHeight + 124 -135
	//$('#dg').datagrid('options').height = dgHeight;
	//$('#dg').datagrid('resize');
	//$('#ReportPanel').panel('options').height = height;
	//$('#ReportPanel').panel('resize');
	
}
*/

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
			$('#XZType').combobox('clear');
			$('#refLtype').combobox('clear');
			setValueById('reflinMedinsNo',"");
 
			$('#XZType').combobox('reload');
			$('#refLtype').combobox('reload');
		  
		    //diagName
		    //diagCode
		    //$('#reflinMedinsName').lookup('clear');
		    // 加载就诊凭证类型
			init_CertType();
			// 加载性别
			init_Sex();
			// 加载医院同意转院标志
			init_hospAgreReflFlag();
			
			
		}	
	})	
	
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
}

function init_SearchINSUType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			$('#Rptlb').combobox('clear');
			$('#Rptlb').combobox('reload');
			init_RefLtype();
			init_RRefLtype();
		}	
	})
}
/*
 * 险种类别
 */
function init_XZType(){
	$HUI.combobox(('#XZType'),{
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
			
		}		
	});

}


/*
 * 转诊类型
 */
function init_RefLtype(){
	$HUI.combobox(('#refLtype'),{
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
			param.Type = 'refl_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
}


/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TTurnType',title:'转诊类型',width:75},
			{field:'TActiveFlag',title:'有效标志',width:80,styler:function(val, index, rowData){
				switch (val){
					case "被作废":
						return "background:red";
						break;
					case "有效":
						return "background:green";
						break;
					case "作废":
						return "background:yellow";
						break;			
				}
			}},	
			{field:'TMemberNo',title:'个人编号',width:120 },
			{field:'TName',title:'患者姓名',width:80 },
			{field:'TIdcardNo',title:'身份证号',width:120},
			{field:'TIcdCode',title:'疾病编码',width:120 },
			{field:'TIcdName',title:'疾病名称',width:150},
			{field:'TTurnCode',title:'申请编号',width:150},
			{field:'TToHospCode',title:'转往医院编码',width:120},
			{field:'TToHospName',title:'转往医院名称',width:150 },
			{field:'TDemo1',title:'联系电话',width:100,hidden:true},
			{field:'TDemo2',title:'联系地址',width:150,hidden:true },
			{field:'TInsuType',title:'医保类型',width:75},
			{field:'TurnDate',title:'转院日期',width:100},
			{field:'TDemo6',title:'开始日期',width:100},
			{field:'TDemo7',title:'结束日期',width:100},
			{field:'TDemo3',title:'医院意见',width:150 },
			{field:'TDemo4',title:'转院原因',width:150 },
			{field:'TDemo5',title:'转院意见',width:150},
			{field:'TDemo8',title:'病情描述',width:150 },
			{field:'TUserDr',title:'经办人',width:150 },
			{field:'TiDate',title:'经办日期',width:100},
		    {field:'TAdmDr',hidden:true},
		    {field:'TInsuAdmInfoDr',hidden:true},
			{field:'TRowid',hidden:true}
		]];

	// 初始化DataGrid
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		toolbar: '#tToolBar',
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
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
	var ExpStr = getValueById('SearchTurnCode') + '|' + getValueById('SearchInsuNo') + '|' + getValueById('SearchName')  + '|' + getValueById('SearchId')  ;
    var queryParams = {

	    ClassName : 'web.DHCINSUReferralInfoCtl',
	    QueryName : 'QueryReferInfo',
	    ReferType : getValueById('RRefLtype'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    ParamINSUType: getValueById('SearchInsuType'),
	    ExpStr:ExpStr
	    
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
	 	setValueById('INSUCardNo',TmpData1[1]);  //卡号
	 	setValueById('name',TmpData1[3]);        //姓名
	 	setValueById('Sex',TmpData1[4]);         //性别
	 	setValueById('insuOptins',TmpData1[21]); //参保人所属地
	 	//setValueById('rylb',TmpData1[11]);     //人员类别	 
	 	setValueById('XZType',TmpData[3]);       //险种类型	
	 
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
		//setValueById("IDCardNo", myAry[8]);
		
		
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
	clear();		
})
$('#btn-readCard').bind('click',function(){
	readHFMagCardClick();	
	//readInsuCardClick();	
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
	//
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
	//setValueById('SDate',getDefStDate(0));
	//setValueById('EDate',getDefStDate(1));
	InsuDateDefault('SDate',-1);	//upt HanZH 20210918	
	InsuDateDefault('EDate');
			
	//setValueById('RRefLtype',"");
	$('#RRefLtype').combobox('reload');	
	//setValueById('StartDate',getDefStDate(0));
	//setValueById('EndDate',getDefStDate(1));
	InsuDateDefault('StartDate',-1);	//upt HanZH 20210918
	InsuDateDefault('EndDate');	
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
*初始化日期格式
*HanZH 20210918
*/
function init_Date(){
	InsuDateDefault('reflDate');
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
// 诊断名称	add HanZH 20210918
function init_diag(){
		$HUI.combobox(('#diagName'),{
		defaultFilter:'4',
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
			setValueById('diagCode',index.code);
		}		
	});
}
/*
 * 医院同意转院标志
 */
function init_hospAgreReflFlag(){
	$HUI.combobox(('#hospAgreReflFlag'),{
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
			param.Type = 'hosp_agre_refl_flag' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}

//转院备案记录记录导出 WangXQ  20220627
function Referexport_Click()
{
	try
   {
	 var ExpStr = getValueById('SearchTurnCode') + '|' + getValueById('SearchInsuNo') + '|' + getValueById('SearchName')  + '|' + getValueById('SearchId')  ;
$.messager.progress({
         title: "提示",
		 msg: '正在导出记录',
		 text: '导出中....'
		   });

$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"转院备案记录",		  
	PageName:"QueryReferInfo",     
	ClassName:"web.DHCINSUReferralInfoCtl",
	QueryName:"QueryReferInfo",
    ReferType : getValueById('RRefLtype'),
	StartDate : getValueById('StartDate'),
	EndDate : getValueById('EndDate'),
	HospId: GV.HospDr,
	ParamINSUType: getValueById('SearchInsuType'),
	ExpStr:ExpStr
},
function(){

	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});
   
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   };	
}

/*
 * 转院类型
 */
function init_RRefLtype(){
	$HUI.combobox(('#RRefLtype'),{
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
			param.Type = 'refl_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
}

//控制病情描述长度，2022/10/15靳帅1010
function FromtLength()
{
	
	var text=getValueById('diseCondDscr');
	
   FromtText=GetParameterLength(TransactionNumber,ParentNodeCode,ParameterCode,GV.HospDr,text);
	
	
	
	}

/*
*清空dg信息
*HanZH 20230328
*/	
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
