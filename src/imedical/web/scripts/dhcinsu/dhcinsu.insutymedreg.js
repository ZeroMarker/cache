/*
 * FileName:	dhcinsu.insutymedreg.js
 * User:		JINS
 * Date:		2022-08-05
 * Function:	医保特药备案修改
 */
 
// 定义常量
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,  //院区ID
	USERID:session['LOGON.USERID'] ,  //操作员ID
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''

}

//入口函数
$(function(){
	setPageLayout();    //设置页面布局
	setElementEvent();	//设置页面元素事件
    setHstep();  //水平步骤
    
});

//设置页面布局
function setPageLayout(){
	
	// 医保类型
	init_INSUType();
	
	// 业务申请类型
	init_bizAppyType();
	
	// 人员证件类型
	init_PsnCertType();
	
	// 代办人证件类型
	init_agnterCertType();
	
	// 代办人关系
	init_agnterRlts();
	
	// 查询面板医保类型
	init_SearchINSUType();
	
	// 查询面板证件类型
	init_CertTypeSearch();
	
	// 定点医药机构名称
	init_fixmedinsName();
	
	// 险种类别
	init_XZType();
	
	// 就诊记录
	initAdmList();
	
	//就诊诊断记录
	InitDiagLst();
	
	//初始化医保特药备案记录	
	init_dg();
	
	//日期初始化	
	init_Date();
	//药品信息
	init_yp();
	
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
 	//药品信息增加
 	$("#btnadd").click(yp_addRow);
 	
 	//药品信息保存
 	$("#btnsave").click(yp_save);
 	
 	//药品信息删除
 	$("#btndel").click(yp_del);
 	
	//定点备案(登记)
	$("#btnFixReg").click(FixReg_Click);
	
    //备案撤销
    $("#btnFixRegDes").click(FixRegDes_Click); 
     
    //备案查询
    $("#btnsearch").click(FixRegsearch_Click); 
    
    //人员定点备案记录查询
    $("#psnfixregSearch").click(initLoadGrid); 
	
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
	$("#CertNoSearch").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	
	//特药备案信息
	$('#btnMsg').bind('click', function () {
		openEditWindow();
	});
	
}

/**
*水平步骤
*/
function setHstep(){

    $('#prevbtn').click(function(){
        $('#hstp').hstep('prevStep');
    });
    $('#nextbtn').click(function(){
        $('#hstp').hstep('nextStep');
    });
    $("#hstp").hstep({
        //showNumber:false,
        stepWidth:200,
        currentInd:1,
        onSelect:function(ind,item){console.log(item);},
        //titlePostion:'top',
        items:[{
                title:'读卡',
                context:""
            },{
                title:'人员信息',
                context:""
            },{
                title:"药品信息", 
                context:""
            },{
                title:"机构信息"
            },{
                title:"备案"
            },{
                title:"记录"
            }]
    });

}
	
/**
*备案登记
*/
function FixReg_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	
	//var PapmiDr="";  //基本信息表Dr
	//var HiType=getValueById('QInsuType');
	//var DclaSouc=1;  //申报来源 1 医院 2 中心
	var ExpStr=""
	//var ExpStr="^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType+"^"+DclaSouc;
	
	var psnNo=getValueById('psnNo');
	if(psnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+psnNo;                                       		//人员编号
	
	
	
	
	var InsuType=getValueById('XZType');
	if(InsuType == "")
	{
		$.messager.alert("温馨提示","险种类型不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+InsuType;                                        //险种类型 
	
	var PsnCertType=getValueById('PsnCertType');
	if(PsnCertType == "")
	{
		$.messager.alert("温馨提示","人员证件类型不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+PsnCertType;                                     //人员证件类型
	
	var CertNo=getValueById('CertNo');
	if(CertNo == "")
	{
		$.messager.alert("温馨提示","证件号码不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+CertNo;                                          //证件号码
	
	
	
	var name=getValueById('name');
	if(name == "")
	{
		$.messager.alert("温馨提示","人员姓名不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+name;                                       		//人员姓名
	
	ExpStr=ExpStr+"^"+getValueById('BrDate');                           //出生日期
	//ExpStr=ExpStr+"^"+getValueById('Sex');                              //性别
	//ExpStr=ExpStr+"^"+getValueById('Naty');                             //民族
	
	
	
	
	var telNo=getValueById('tel');
	if(telNo == "")
	{
		$.messager.alert("温馨提示","联系电话不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+telNo;                                             //联系电话
	var addr=getValueById('addr');
	if(addr == "")
	{
		$.messager.alert("温馨提示","联系地址不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+addr;                                             //联系地址
	
	insuOptins
	
	var insuOptins=getValueById('insuOptins');
	if(insuOptins == "")
	{
		$.messager.alert("温馨提示","参保所属医保区划不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+insuOptins;                                             //参保所属医保区划
	
	
	
	var fixmedinsCode=getValueById('fixmedinsCode');
	/*if(fixmedinsCode == "")
	{
		$.messager.alert("温馨提示","备案定点医药机构编码不能为空!", 'info');
		return ;
	}
	*/
	ExpStr=ExpStr+"^"+fixmedinsCode;                                             // 备案定点医药机构编码
	
	
	var fixmedinsName=getValueById('fixmedinsName');
	/*
	if(fixmedinsName == "")
	{
		$.messager.alert("温馨提示","备案定点医药机构名称不能为空!", 'info');
		return ;
	}
	*/
	ExpStr=ExpStr+"^"+fixmedinsName;                                             // 备案定点医药机构名称
	
	
	var SDate=getValueById('SDate');	
	if(SDate == "")
	{
		$.messager.alert("温馨提示","开始日期不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+SDate;                                        	//开始日期
	
	var EDate=getValueById('EDate');	
	if(EDate == "")
	{
		$.messager.alert("温馨提示","结束日期不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+EDate;                                        	//结束日期
	
	var agnterName=getValueById('agnterName');	
	if(agnterName == "")
	{
		$.messager.alert("温馨提示","代办人姓名不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+agnterName;                                       //代办人姓名
	
	var agnterCertType=getValueById('agnterCertType');	
	if(agnterCertType == "")
	{
		$.messager.alert("温馨提示","代办人证件类型不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+agnterCertType;                                   //代办人证件类型
	
	var agnterCertNo=getValueById('agnterCertNo');	
	if(agnterCertNo == "")
	{
		$.messager.alert("温馨提示","代办人证件号码不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+agnterCertNo;                                    //代办人证件号码
	
	var agnterTel=getValueById('agnterTel');	
	if(agnterTel == "")
	{
		$.messager.alert("温馨提示","代办人联系方式不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+agnterTel;                                      //代办人联系方式
	
	var agnterAddr=getValueById('agnterAddr');	
	if(agnterAddr == "")
	{
		$.messager.alert("温馨提示","代办人联系地址不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+agnterAddr;                                      //代办人联系地址
	
	var agnterRlts=getValueById('agnterRlts');	
	if(agnterRlts == "")
	{
		$.messager.alert("温馨提示","代办人关系不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+agnterRlts;                                      //代办人关系
	
	
	
	var TMemo="";
	ExpStr=ExpStr+"^"+TMemo;                                 //备注
	
	var diagCode=getValueById('diagCode');
	if(diagCode == "")
	{
		$.messager.alert("温馨提示","诊断编码不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+diagCode;                                             //诊断编码
	
	var diagName=getValueById('diagName');
	if(diagName == "")
	{
		$.messager.alert("温馨提示","诊断名称不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+diagName+"#";                                             //诊断名称
	

	
	/*
	*
	var condAbst=getValueById('condAbst');
	if(condAbst == "")
	{
		$.messager.alert("温馨提示","诊断依据不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+condAbst;                                        //诊断依据 
	
	var appyLmt=getValueById('appyLmt');
	if(appyLmt == "")
	{
		$.messager.alert("温馨提示","申请限额不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+appyLmt;                                         //申请限额 
	

	
	var appyDate=getValueById('appyDate');	
	if(appyDate == "")
	{
		$.messager.alert("温馨提示","申请日期不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+appyDate;                                        	//申请日期
	
	var drNo=getValueById('drNo');	
	if(drNo == "")
	{
		$.messager.alert("温馨提示","医生编号不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+drNo;                                        	    //医生编号
	
	var drName=getValueById('drName');	
	if(drName == "")
	{
		$.messager.alert("温馨提示","医生姓名不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+drName;                                        	//医生姓名
	
**/
	


//药品信息

    var SelectIndex = INSUMIGetEditRowIndexByID('ypgrid');
	if(SelectIndex > -1){
		$('#ypgrid').datagrid('endEdit',SelectIndex);
	}
	if (!$('#ypgrid').datagrid('validateRow', SelectIndex)) {
		$.messager.popover({msg: '数据验证不通过', type: 'error'});
		return;
	}
	var TotalNum = 0;
	var SuccessNum = 0;
	var ErrorNum = 0;
	var dgRows = $('#ypgrid').datagrid('getChanges');
	for (var rowIndex = 0; rowIndex < dgRows.length; rowIndex++) {
		var dgRow = dgRows[rowIndex];
		if(dgRow){
			TotalNum++;
			var dgSelectRowId = dgRow.ROWID || '';
			var dgSelectIndex = $('#ypgrid').datagrid('getRowIndex',dgRow);
			$('#ypgrid').datagrid('beginEdit',dgSelectIndex);
    	 ExpStr= ExpStr+INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'hilist_code')+"^"+     //药品信息
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'hilist_name')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'cnt')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'cnt_prcunt')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'memo')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'poolarea')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'used_num')+"|";
		}
		}
	/*
	var telNo=getValueById('tel');
	if(telNo == "")
	{
		$.messager.alert("温馨提示","联系电话不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+telNo;                                             //联系电话
	
	var bizAppyType=getValueById('bizAppyType');
	if(bizAppyType == "")
	{
		$.messager.alert("温馨提示","业务申请类型不能为空!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+bizAppyType;                                       //业务申请类型
	*/
	/*
	$m({
		ClassName:"INSU.MI.BL.PsnFixRegCtl",
		MethodName:"InsertPsnFixReg",
		InString:ExpStr,
		HospDr:GV.HospDr,
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('提示',"人员定点备案登记失败："+rtn);
		}else{
			   $.messager.alert('提示','人员定点备案登记成功');
			}
	  $.messager.progress("close");
	});
	*/
	                                     
}
	
			
/**
*备案撤销
*/

function FixRegDes_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			
			$.messager.confirm('确认', '确认撤销备案记录？', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr
					if(AdmDr == "")
					{
						$.messager.alert("温馨提示","请选择一条备案记录", 'info');
						return ;
					}
    
    				var ExpString="需要重新备案" //格式:^^^数据库连接串
					var rtn=INSUTransferHosApproveDestory(Handle, UserId , AdmDr , ExpString); //DHCINSUPort.js
					if (rtn!="0") 
	 				{
						$.messager.alert("提示","人员定点备案撤销失败!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("提示","人员定点备案撤销成功!", 'info',function(){
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

/**
*备案查询
*/
function FixRegsearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //格式:^^^数据库连接串
			var rtn=InsuTransferHospQuery(Handle,UserId,selected.TRowid,ExpString); //DHCINSUPort.js
			if (rtn!="0"){
						$.messager.alert("温馨提示","查询备案信息失败", 'info');
						return ;
				}else{
						$.messager.alert("温馨提示","查询备案信息成功", 'info');
						return ;
					}
			
			}else{
				$.messager.alert('提示', "请选择要撤销的记录", 'info');		
				return false;
		}	
	}
}


/**
*初始化定点医药机构
*/
function init_fixmedinsName(){
	
    var data={total:0,rows:[]};
	$('#fixmedinsName').combogrid({
    panelWidth:470,
    value:'006',
    idField:'fixmedins_code',
    textField:'fixmedins_name',
    delay: 600,
	mode: 'remote',
	method: 'GET',
	pagination: true,
    columns:[[
        {field:'fixmedins_code',title:'医药机构编号',width:160},
        {field:'fixmedins_name',title:'医药机构名称',width:310},
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
				  $("#fixmedinsName").combogrid("grid").datagrid({data:data});
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
					 $("#fixmedinsName").combogrid("grid").datagrid({data:newData});
			    }
			}else{
				$('#fixmedinsName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('fixmedinsCode',row.fixmedins_code);
		}
});
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
			GetInsuAdmInfo();                 //获取医保就诊信息
			       
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
			  var DiagLstVal=rowData.DiagnosICDCode+"/"+rowData.DiagnosDesc+"/"+rowData.DiagnosMRDesc+"/"+rowData.DiagStat+"/"+rowData.InsuDiagCode+"/"+rowData.InsuDiagDesc
		      $('#DiagLst').combogrid("setValue",DiagLstVal)
			  setValueById('diagCode',rowData.DiagnosICDCode)
			  setValueById('diagName',rowData.DiagnosDesc)
		}
       
  });  

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
			// 加载业务申请类型
			init_bizAppyType();
			// 加载人员证件类型
			init_PsnCertType();
			// 加载代办人证件类型 
			init_agnterCertType();
			// 加载代办人关系
			init_agnterRlts();
		}	
	})
		
}

/*
 * 业务申请类型 
 */
function init_bizAppyType(){
	$HUI.combobox(('#bizAppyType'),{
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
			param.Type = 'biz_appy_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
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

		}		
	});
	
}

/*
 * 代办人证件类型 
 */
function init_agnterCertType(){
	$HUI.combobox(('#agnterCertType'),{
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
			
		}		
	});
}

/*
 * 代办人关系
 */
function init_agnterRlts(){
	$HUI.combobox(('#agnterRlts'),{
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
}

/*
 *查询面板医保类型
 */
function init_SearchINSUType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			
			// 加载查询面板证件类型 
			init_CertTypeSearch();
			// 加载查询面板业务申请类型 
			//init_bizAppyTypeSearch();
		},	
		
	})
}

/*
 * 查询面板证件类型
 */
function init_CertTypeSearch(){
	$HUI.combobox(('#CertTypeSearch'),{
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

		}		
	});
	
}

/*
 * 查询面板业务申请类型 
 
function init_bizAppyTypeSearch(){
	$HUI.combobox(('#bizAppyTypeSearch'),{
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
			param.Type = 'biz_appy_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
}

*/
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
 * datagrid
 */
function init_dg() {
	// 初始化DataGrid
	$('#dg').datagrid({
		fit:true,
		data:[],
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		frozenColumns:[[
			{field:'TBizAppyType',title:'业务申请类型',width:150},
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
				}
			}},	
			{field:'TPsnNo',title:'个人编号',width:120 },
			//{field:'TPsnName',title:'患者姓名',width:80 },
			//{field:'TPsnCertType',title:'人员证件类型',width:150},
			//{field:'TCertNo',title:'证件号码',width:150},
			{field:'TTel',title:'联系电话',width:100,hidden:true},
			{field:'TAddr',title:'联系地址',width:150,hidden:true },
				
			]],
		columns:[[ 
			{field:'THiType',title:'医保类型',width:100},
			{field:'TBegndate',title:'开始日期',width:100},
			{field:'TEnddate',title:'结束日期',width:100},
			{field:'TAgnterName',title:'代办人姓名',width:100 },
			{field:'TAgnterCertType',title:'代办人证件类型',width:160 },
			{field:'TAgnterCertno',title:'代办人证件号码',width:150 },
			{field:'TAgnterTel',title:'代办人联系方式',width:150 },
			{field:'TAgnterAddr',title:'代办人联系地址',width:150 },
			{field:'TAgnterRlts',title:'代办人关系',width:150 },
			{field:'TFixSrtNo',title:'定点排序号',width:150 },
			{field:'TFixmedinsCode',title:'定点医药机构编号',width:150 },
			{field:'TFixmedinsName',title:'定点医药机构名称',width:150 },
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
			{field:'TDclaSouc',hidden:true}, //申报来源
			{field:'TInsuAdmdvs',hidden:true}, //参保所属医保区划
			{field:'TInsutype',hidden:true} //险种类型
		]],
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
	var queryParams = {
		ClassName : 'INSU.MI.BL.PsnFixRegCtl',
		QueryName:'QueryPsnFixReg',
		StartDate : getValueById("StartDate"),
	    EndDate : getValueById("EndDate"),
	    HiType : getValueById("SearchInsuType"),
	    InsuNo : getValueById("SearchInsuNo"),
	    PsnName : getValueById("PsnNameSearch"),
	    PsnCertType : getValueById("CertTypeSearch"),
	    CertNo : getValueById("CertNoSearch"),
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
	 	//setValueById('Sex',TmpData1[4]);         //性别
	 	setValueById('insuOptins',TmpData1[21]); //参保人所属地
	 	//setValueById('rylb',TmpData1[11]);     //人员类别	 
	 	//setValueById('XZType',TmpData[3]);       //险种类型	
	 
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
	initLoadGrid();
	//
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
	//setValueById('SDate',getDefStDate(0));
	//setValueById('EDate',getDefStDate(1));
	InsuDateDefault('SDate',-1);	//upt HanZH 20210918	
	InsuDateDefault('EDate');
			
	//setValueById('RRefLtype',"");
	//$('#RRefLtype').combobox('reload');	
	//setValueById('StartDate',getDefStDate(0));
	//setValueById('EndDate',getDefStDate(1));
	InsuDateDefault('StartDate',-1);	//upt HanZH 20210918
	InsuDateDefault('EndDate');	
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
*初始化日期格式
*HanZH 20210918
*/
function init_Date(){
	InsuDateDefault('SDate');
	InsuDateDefault('EDate');
	InsuDateDefault('appyDate');
	}

/* 查询弹窗
 */
function openEditWindow(){
	$('#LocalListInfoProWin').show(); 
	$HUI.dialog("#LocalListInfoProWin",{
			title:"备案信息",
			height:700,
			width:1300,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	
	init_AddInfoPanel();	
	
}

/* 
 * 新增弹窗
 */
function init_AddInfoPanel(){
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(1));
	
}

/*
*药品信息
*/
function init_yp(){ 
     
     $('#ypgrid').datagrid({
	   fit:true,
	   columns:[[
	 {field:'hilist_code',title:'医保目录编码', width:200,editor:{
				type: 'text',
				options: {
					required:true
				}
			}},
    
    {field:'hilist_name',title:'医保目录名称', width:360,editor:{
				type: 'combogrid',
				options: {
			           
						idField: 'INTIMxmmc',
						
						textField: 'INTIMxmmc',
						method: 'GET',
						mode: 'remote',
		                pagination: true,
						required: true,
						data:[],
						columns: [
			            [{field: 'rowid', title: 'Rowid', hidden: true},
			            {field: 'INTIMxmbm', title: '医保目录编码', width: 130},
			            {field: 'INTIMxmmc', title: '医保目录名称', width: 130},
			 
			            {field: 'INTIMjx', title: '剂型', width: 30},
			            {field: 'INTIMgg', title: '规格', width: 30},
			            {field: 'INTIMdw', title: '单位', width: 30},
			            {field: 'INTIMzfbl1', title: '自付比例1', width: 30},
			            {field: 'INTIMActiveDate', title: '生效日期', width: 230},
			            {field: 'INTIMExpiryDate', title: '失效日期', width: 230}]
		                ],
		                onBeforeLoad: function(param) {
			
			
				$(this).datagrid("options").url = $URL;
				param.ClassName = "web.INSUTarItemsCom";
				param.QueryName = "QueryAll";
				
				param.txt=param.q;
			    param.Class='3';
			    param.Type = getValueById('SearchInsuType');
				param.zfblTmp='';
				param.ExpStr='09';   //收费大类编码  09 西药费，10中药饮片费，11中成药费
				param.HospDr='2';
				
				return true;
			
			
		},
		      onSelect: function(index, data) {
			      var SelectIndex = INSUMIGetEditRowIndexByID('ypgrid');
			 
			 
			      INSUMIDataGrid.setGridVal('ypgrid',SelectIndex,'hilist_code',data.INTIMxmbm);
			      INSUMIDataGrid.setGridVal('ypgrid',SelectIndex,'hilist_name',data.INTIMxmmc);
			      INSUMIDataGrid.setGridVal('ypgrid',SelectIndex,'cnt_prcunt',data.INTIMdw);
		
     
		},
		                
		
	}
			}},
    {field:'cnt',title:'数量', width:200,editor:{
				type: 'numberbox',
				options: {
					required:true
				}
			}},
    {field:'cnt_prcunt',title:'数量单位', width:200,editor:{
				type: 'text',
				options: {
					required:true
				}
			}},
    {field:'memo',title:'备注', width:200,editor:{
				type: 'text',
				options: {
					required:true
				}
			}},
    {field:'poolarea',title:'统筹区', width:200,editor:{
				type: 'text',
				options: {
					required:true
				}
			}},
    {field:'used_num',title:'已用数量', width:200,editor:{
				type: 'numberbox',
				options: {
					required:true
				}
			}}
    ]],
	 
	   data:[],
	   fitColumns:true

       

	
	 
  
	  });
	}
//新增药品信息

/*formatter: function(value,row,index){
                if (row.user){
                    return row.user.name;
                } else {
                    return value;
                }
            }
 */
 //新增一行
function yp_addRow(){
 var SelectIndex = INSUMIGetEditRowIndexByID('ypgrid');
	if(SelectIndex > -1){
	
	if (!$('#ypgrid').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '数据验证不通过', type: 'error'});
			return;
		}
		$('#ypgrid').datagrid('endEdit',SelectIndex);
	}
 var lastRows = $('#ypgrid').datagrid('getRows').length;
 datagrid=$('#ypgrid').datagrid('appendRow', {
			hilist_code: '',
			hilist_name: '',
			cnt: '1',
			cnt_prcunt: '',
			memo: '',
			poolarea: '',
			used_num: '0',
			
				
	});
    $('#ypgrid').datagrid('beginEdit', lastRows);
	$('#ypgrid').datagrid('scrollTo', lastRows);
	$('#ypgrid').datagrid('selectRow', lastRows);

	}



//保存药品信息
function yp_save(){

	}
/*测试药品拼串
function yp_save(){
	var test="";
 var SelectIndex = INSUMIGetEditRowIndexByID('ypgrid');
	if(SelectIndex > -1){
		$('#ypgrid').datagrid('endEdit',SelectIndex);
	}
	if (!$('#ypgrid').datagrid('validateRow', SelectIndex)) {
		$.messager.popover({msg: '数据验证不通过', type: 'error'});
		return;
	}
	var TotalNum = 0;
	var SuccessNum = 0;
	var ErrorNum = 0;
	var dgRows = $('#ypgrid').datagrid('getChanges');
	for (var rowIndex = 0; rowIndex < dgRows.length; rowIndex++) {
		var dgRow = dgRows[rowIndex];
		if(dgRow){
			TotalNum++;
			var dgSelectRowId = dgRow.ROWID || '';
			var dgSelectIndex = $('#ypgrid').datagrid('getRowIndex',dgRow);
			$('#ypgrid').datagrid('beginEdit',dgSelectIndex);
    	 test= test+"^"+INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'hilist_code')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'hilist_name')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'cnt')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'cnt_prcunt')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'memo')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'poolarea')+"^"+
		 INSUMIDataGrid.getCellVal('ypgrid',dgSelectIndex,'used_num')+"|";
		}
		}
		alert(test);
	}
*/
//删除药品信息
function yp_del(){
	var row=$('#ypgrid').datagrid('getSelections');
	if(row){
		for(var i=0; i<row.length;i++){
			var rowIndex=$('#ypgrid').datagrid('getRowIndex',row[i]);
			$('#ypgrid').datagrid('deleteRow',rowIndex);
			
			}
		}
	}