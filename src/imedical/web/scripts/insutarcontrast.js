/**
 * 医保目录对照JS
 * Zhan 201409
 * 版本：V1.0
 * easyui版本:1.3.2
 */
$(function(){
	GetjsonQueryUrl();
	//回车事件
	init_Keyup();
	//医院目录下拉列表
	init_INSUTarcSearchPanel();
	//初始化对照的grid west
	init_dg();
	//医保目录(医保中心) east
	init_wdg();
	//对照明细历史 south
	init_ContraHistory();
	// 自适应
	init_layout();
	//授权管理
	if(BDPAutDisableFlag('btnAdd')==true){$('#btnAdd').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDelete')==true){$('#btnDelete').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDld')==true){$('#btnDld').linkbutton('disable');}
	if(BDPAutDisableFlag('btnUpload')==true){$('#btnUpload').linkbutton('disable');}
	$('#south-panel').panel('collapse');

}); 
//查询HIS对照数据
function Query(){
	var queryParam={
		TarId : '',
		HisDesc : ''	
	}
	ConGridQuery(0,queryParam); //每次查询先清空对照历史
	
	var TarCate=$('#TarCate').combobox('getValue')
	if("0"==TarCate){
		TarCate=""; //全部
	}
	
	var TarDate = getValueById('TarDate'); // 2019-12-19 收费项日期 add by tangzf 
	var PrtFlag = 'N'; // 老版本使用，新版本不用
	var ExpStr = PrtFlag + '|' + TarDate + '|' + PUBLIC_CONSTANT.SESSION.HOSPID;

	var queryParams = {
		ClassName : 'web.INSUTarContrastCom',
		QueryName : 'DhcTarQuery',
		sKeyWord : $('#KeyWords').val(),
		Class : $('#QClase').combobox('getValue'),
		Type : $('#insuType').combobox('getValue'),
		ConType : $('#ConType').combobox('getValue'),
		TarCate : TarCate,
		ActDate : TarDate,
		ExpStr : ExpStr	
	}
	loadDataGridStore('dg',queryParams);
}
//查询医保目录数据
function QueryINSUTarInfoNew(field,qclass){
	var fieldVal = getValueById(field);
	var tmpurl=jsonQueryUrl+'web.INSUTarItemsCom'+SplCode+"QueryAll"+SplCode+cspEscape(fieldVal)+ArgSpl+qclass+ArgSpl+cspEscape($('#insuType').combobox('getValue'))+ArgSpl+ArgSpl+cspEscape($('#TarCate').combobox('getValue'))+'|'+cspEscape($('#TarCate').combobox('getText'));
	$('#wdg').datagrid({ url:tmpurl, queryParams: { qid:1}});	
}
function ShowInsuDetlsbyID(inVal,sindex,qclass){
	var url = "dhcinsutareditcom.csp?&InItmRowid=" + inVal+'&AllowUpdateFlag='+'N&Hospital=' + PUBLIC_CONSTANT.SESSION.HOSPID + '&INSUType=' + $('#insuType').combobox('getValue'); //?&ItmRowid=" + rowData.Rowid;
	websys_showModal({
		url: url,
		title: "医保目录维护",
		iconCls: "icon-w-edit",
		width: "855",
		height: "710",
		onClose: function()
		{
			rowData=$('#dg').datagrid('getSelected');
			ConGridQuery(0,rowData);
		}
	});
}
//确认并保存数据
function SaveCon(rowIndex,selInsuData){
	var selTarData = $('#dg').datagrid('getSelected');
	var sconActDate = $('#dd').datebox('getValue');
	var userID = session['LOGON.USERID'];
	var userName = session['LOGON.USERNAME'];
	if (("" != sconActDate) && (undefined != sconActDate) && ("" != selInsuData.INTIMExpiryDate) && (undefined != selInsuData.INTIMExpiryDate) && compareDate(sconActDate, selInsuData.INTIMExpiryDate)) {
		$.messager.alert("警告", "此项目已作废!请选择其它项目!",'info');
		return;
	}
	if( (!selTarData) || (""==selInsuData)||(undefined==selInsuData.rowid)){
    	$.messager.alert('提示', '请选择要对照的记录!','info');
		return;
	}
  	$.messager.confirm('提示', '你确认要把 ' + selTarData.HisDesc + ' 对照成 ' + selInsuData.INTIMxmmc + ' 吗?', function (r) {
	    if (r) {
	      //如果有乱码就用JS的cspEscape()函数加密
	      var UpdateStr = "^" + selTarData.TarId + "^" + selTarData.HisCode + "^" + (selTarData.HisDesc) + "^" + selInsuData.rowid + "^" + selInsuData.INTIMxmbm + "^" + (selInsuData.INTIMxmmc) + "^" + "^" + "^" + "^" + 1 + "^" + "^" + sconActDate + "^" + "^" + $('#insuType').combobox('getValue') + "^" + userID + "^" + "^";
	      var savecode = tkMakeServerCall("web.INSUTarContrastCom", "Insert", "", "", UpdateStr);
	      if (eval(savecode) > 0) {
	        MSNShow('提示', '对照成功！', 2000);
	        if (selTarData) {
	          var dgindex = $('#dg').datagrid('getRowIndex', selTarData);
	          $('#dg').datagrid('updateRow', { index: dgindex, row: { ConId: eval(savecode), InsuCode: selInsuData.INTIMxmbm, InsuDesc: selInsuData.INTIMxmmc, conActDate: sconActDate, UserDr: userName, ConDate: GetToday(), ConTime: GetTime() } });
	        }
	        movenext($('#dg'));
	      } else {
	      	$.messager.alert('提示', '保存失败!','info');
	      }
	      ConGridQuery(0, selTarData);
	    } else {
	    	return false;
	    }
		$('#wdg').datagrid('unselectAll');
  });
}
function movenext(objgrid){
	var myselected = objgrid.datagrid('getSelected');
	if (myselected) {
		var index = objgrid.datagrid('getRowIndex', myselected);
		var tmprcnt=objgrid.datagrid('getRows').length-1
		if(index>=tmprcnt){return;}
		objgrid.datagrid('selectRow', index + 1);
	} else {
		objgrid.datagrid('selectRow', 0);
	}	
}

//作废记录
function DelCon(rowIndex){
	if(typeof rowIndex == 'number' ||typeof rowIndex == 'string'){
		$('#coninfo').datagrid('selectRow', rowIndex);
	}
	var tmpdelid=""
	var selected = $('#coninfo').datagrid('getSelected');
	var selTarData = $('#dg').datagrid('getSelected');
	if (selected){
		if((selected.ConId!="")&&(undefined!=selected.ConId)){    // 增加undefined 验证 DingSH 20170221
			tmpdelid=selected.ConId
		}
	}	
	if(tmpdelid==""){$.messager.alert('提示','请选择要作废的记录!','info');return;} 
	
	$.messager.confirm('请确认','你确认要作废这条记录吗?',function(fb){
		if(fb){
			
			//DingSH 20161204  针对已经上传
			//备注：DrAddFlag  为空是表示目录本地对照没有上传医保中心
            //      DrAddFlag  为1是表示目录上传医保中
           //       DrAddFlag  为2是表示目录中心已经审核
           //       DrAddFlag  为3是表示目录中心审核不通
            var InDelFlag=""
			if((selected.DrAddFlag!="")&&(null!=selected.DrAddFlag))
			{
				//InDelFlag=InsuTarConDel(dHandle,UserId,conId,ExpStr) //DHCINSUPort.js  返回值：0:成功，-1:失败 医保目录对照 ExpStr:"医保类型^审核标识^^^"
				 InDelFlag="-1" ;//测试用
				
			}
			if (InDelFlag=="-1"){$.messager.alert('提示','作废医保中心的对照数据失败，不允许作废本地对照关系!','info'); return ;}
			
			
			var savecode=tkMakeServerCall("web.INSUTarContrastCom","Abort",tmpdelid,"")
			if(eval(savecode)>=0){
				//$.messager.alert('提示','删除成功!');  
				MSNShow('提示','作废成功！',2000) 
				if (selTarData) {
					var dgindex = $('#dg').datagrid('getRowIndex', selTarData);
					$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId:'',InsuCode:'',InsuDesc:''}});
				}
			}else{
				$.messager.alert('提示','作废失败!','info');   
			}
			ConGridQuery(0,selTarData)
		}else{
			return;	
		}
	});
	
}
//查询对照历史记录
function ConGridQuery(rowIndex,rowData){
	var selTarData=rowData;
	var conurl=jsonQueryUrl+'web.INSUTarContrastListCom'+SplCode+"QueryConList"+SplCode+selTarData.TarId+ArgSpl+$('#insuType').combobox('getValue')+ArgSpl;
	$('#coninfo').datagrid({ url: conurl, queryParams: {qid:1}});
}

function fillConGridEdit(rowIndex,rowData){
	var dateVal = $('#dd').datebox('getValue');
	if (("" != dateVal) && (undefined != dateVal) && ("" != rowData.INTIMExpiryDate) && (undefined != rowData.INTIMExpiryDate) && compareDate(dateVal, rowData.INTIMExpiryDate)) {
		//$.messager.alert("警告", "此项目已作废!请选择其它项目!",'info');
		$('#wdg').datagrid('unselectRow',rowIndex);
		return false;
	}
}  
//导出EXCEL
function Export(){
	try
	{
		var TarCate=$('#TarCate').combobox('getValue');
		if("0"==TarCate){TarCate=""}
		var title="";
		//ExportMed=1;
		//var tmpurl=jsonQueryUrl+'web.INSUTarContrastCom'+SplCode+"DhcTarQuery"+SplCode+cspEscape($('#KeyWords').val())+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+$('#insuType').combobox('getValue')+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl+TarCate+ArgSpl+ArgSpl
		//ExportTitle="^^医院收费项编码^医院收费项名称^单位^收费类别^收费子类^单价^对照ID^^医保代码^医保名称^^医保规格^医保单位^自付比例^医保费用类别^项目等级^生效日期^^限制标志^厂家^HIS录入日期^备注^操作员^对照日期^对照时间^失效日期^批准文号"
		//ExportPrompt(tmpurl)
		
		ExportMed=2;
		var selHosDr=""
		if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
		var tmprqurl=jsonQueryUrl+'web.INSUTarContrastCom'+SplCode+"DhcTarQuery"+SplCode+"InsuTarcontrast.rpx&sKeyWord="+cspEscape($('#KeyWords').val())+"&Class="+$('#QClase').combobox('getValue')+"&Type="+$('#insuType').combobox('getValue')+"&ConType="+$('#ConType').combobox('getValue')+"&TarCate="+TarCate+"&ActDate="+$("#ActDate").datebox('getValue')+"&ExpStr=||" + selHosDr;
		ExportPrompt(tmprqurl)
		
		//var rtn = tkMakeServerCall("websys.Query","ToExcel","excelname","web.INSUTarContrastCom","DhcTarQuery",cspEscape($('#KeyWords').val()),$('#QClase').combobox('getValue'),$('#insuType').combobox('getValue'),$('#ConType').combobox('getValue'),$('#TarCate').combobox('getValue'),"","");
		//var rtn = tkMakeServerCall("web.INSUJSONBuilder","ToExcel","excelname","web.INSUTarContrastCom","DhcTarQuery",cspEscape($('#KeyWords').val())+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+$('#insuType').combobox('getValue')+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl+$('#TarCate').combobox('getValue')+ArgSpl+ArgSpl);
		//location.href = rtn;
		return;
	} catch(e) {
		$.messager.alert("警告",e.message,'info');
		$.messager.progress('close');
	};
}
function isEditing(objgrid){
	if (EditIndex == undefined){return true}
	if (objgrid.datagrid('validateRow', EditIndex)){
		//var ed = grid.datagrid('getEditor', {index:EditIndex,field:'INSUDigCode'});
		//var productname = $(ed.target).combobox('getText');
		//grid.datagrid('getRows')[EditIndex]['INSUDigCode'] = productname;
		objgrid.datagrid('endEdit', EditIndex);
		
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

//上传医保目录对照
function Upload(){
	//var rtnflag=INSUUpLoadConAudit($('#insuType').combobox('getValue')); tangzf 2019-11-12 '-'
	var UserId = session['LOGON.USERID'];
	var ConDr = '';
	var InsuType = $('#insuType').combogrid('getValue');
	var ActDate = getValueById('ActDate');
	//alert(InsuType)
	if(InsuType == '' ){
		$.messager.alert('提示','医保类型不能为空','info');	
		return;	
	}
	if( ActDate == '' ){
		$.messager.alert('提示','生效日期不能为空','info');	
		return;	
	}
	var ExpString = InsuType + '^^' + ActDate; //医保类型^^生效日期^
	var rtnflag = InsuTarConUL('0',UserId,ConDr,ExpString);
	if(rtnflag == "0"){
		$.messager.alert('提示','对照上传成功!','info');
	}else{
		$.messager.alert('提示','对照上传失败!','info');
	}

}
//下载医保目录
function Download(){
	var rtnflag=InsuBasDL($('#insuType').combobox('getValue'),"")
	if(rtnflag=="0"){
		$.messager.alert('提示','医保目录下载失败!','info')
	}else{
		$.messager.alert('提示','医保目录下载成功!','info')
	}

}
// 通过其他界面(收费项目维护) 链接过来 并且传了收费项参数 自动赋值，查询
function AutQuery(){
	if(TarCode!=""){
		$('#QClase').combobox('setValue','2')
		$('#KeyWords').val(TarCode)
		Query()
	}	
}
function GetDicStr(dicCode,CodeVal,index){
	return tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",dicCode,CodeVal,index,PUBLIC_CONSTANT.SESSION.HOSPID)
}


///获取配置的默认生效时间
///注意：如果为空默认当前时间
function GetConDateByConfig()
{
    var rtnDate=""
	var rtnDate=GetDicStr("SYS","INSUCONACTDATE",6);
	if(rtnDate==""){ 
		rtnDate=curDate();
	}
	return rtnDate; 
 }
 ///获取当前时间,支持时间格式
 function curDate() {
	return getDefStDate(0);
 }
 
//add by Huang SF
//比较日期大小，支持时间格式:
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
///返回值：true:One大,false:else
function compareDate(DateOne, DateTwo,Flag) {
  var Flag=tkMakeServerCall("websys.Conversions","DateFormat")
  if ("1"==Flag){
	  if(Date.parse(DateOne) > Date.parse(DateTwo)) {
		  return true;
  	  } else {
	  	  return false;
	  }
  }
  if("3"==Flag){
	  var DateOneTemp=new Date(DateOne.replace("-","/"));
	  var DateTwoTemp=new Date(DateTwo.replace("-","/"));
	  if(Date.parse(DateOneTemp) > Date.parse(DateTwoTemp)) {
		  return true;
  	  } else {
	  	  return false;
	  }
  }
  if("4"==Flag){
	var OneMonth = DateOne.substring(3, DateOne.lastIndexOf("/"));
  	var OneDay = DateOne.substring(0, DateOne.indexOf("/"));
  	var OneYear = DateOne.substring(DateOne.lastIndexOf("/")+1,DateOne.length);
  	var TwoMonth = DateTwo.substring(3, DateTwo.lastIndexOf("/"));
  	var TwoDay = DateTwo.substring(0, DateTwo.indexOf("/"));
  	var TwoYear = DateTwo.substring(DateTwo.lastIndexOf("/")+1,DateTwo.length);
  	if (Date.parse(OneMonth + "/" + OneDay + "/" + OneYear) > Date.parse(TwoMonth + "/" + TwoDay + "/" + TwoYear)) {
    	return true;
  	} else {
   	 return false;
  	}  
  }
  return false;
}
/**
 * Creator: tangzf
 * CreatDate: 2019-6-12
 * Description: 查询面板回车事件
 */
function init_Keyup() {
	//医保目录对照
	$('#KeyWords').keyup(function(){
		if(event.keyCode==13){
			Query();
		}
	});
	//医保目录(医保中心)
	$('.textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			btnFindInsu_Click(e.target.id)	
		}
	});
}
function btnFindInsu_Click(code){
	switch (code) {
		case 'InsuCode':
			QueryINSUTarInfoNew('InsuCode','2');
			break;
		case 'InsuDesc':
			QueryINSUTarInfoNew('InsuDesc','3');
			break;
		case 'Insurj':
			QueryINSUTarInfoNew('Insurj','1');
			break;
		case 'PZWH':
			QueryINSUTarInfoNew('PZWH','5');
			break;
		default:
			break;
	}
}
//south 布局
function init_layout(){
	var collectButtonLeft=parent.$('.fa-angle-double-left');

	if(collectButtonLeft.length>0){
		$("#TDTarDate").hide(); 
		$("#LabelTarDate").hide(); 
		//collectButtonLeft.click(); // 自动折叠测菜单
		parent.$('.fa-angle-double-left').on('click', function (e) {	
			window.location.reload(true); 	
    	});	
	}
	var collectButtonRight=parent.$('.fa-angle-double-right');
	if(collectButtonRight.length>0){
		$("#TDTarDate").show(); 
		$("#LabelTarDate").show(); 
		parent.$('.fa-angle-double-right').on('click', function (e) {
			//window.location.reload(true);
    	});
	}
	if(window.screen.availWidth<1440){
		//解决低分辨率按钮变形
		$('#searchTablePanel').find('.hisui-panel').css('width',window.document.body.offsetWidth); 
		$('#searchTablePanel').find('.panel-header').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('height','107px');
		$('#searchTablePanel').css('overflow','scroll');
		
	}
}
//医保目录对照(HIS) 查询条件初始化
function init_INSUTarcSearchPanel() { 
	var dicurl = jsonQueryUrl + 'web.INSUDicDataCom' + SplCode + "GetDicJSONInfo" + SplCode + "TariType^^";	//ArgSpl
	// 医保类型
	var diccombox = $('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
      	rownumbers:true,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:dicurl,
	    columns:[[   
	        {field:'INDIDDicCode',title:'代码',width:60},  
	        {field:'INDIDDicDesc',title:'描述',width:100}
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
			$('#insuType').combogrid('grid').datagrid('selectRow',0);
			AutQuery();
		}
	}); 
	//对照关系
	$('#ConType').combobox({  
	    panelHeight:200, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [{
			Code: 'A',
			Desc: '查询所有',
			selected:true
		},{
			Code: 'Y',
			Desc: '查询已对照项'
		},{
			Code: 'N',
			Desc: '查询未对照项'
		},{
			Code: '0',
			Desc: '查询未上传项'
		},{
			Code: '1',
			Desc: '查询已上传项'
		},{
			Code: '2',
			Desc: '查询已审核项'
		},{
			Code: '3',
			Desc: '查询未审核项'
		}]
	}); 
	// 项目大类
	var TarCateurl=jsonQueryUrl+'web.INSUTarContrastCom'+SplCode+"GetTarCate"+SplCode+session['LOGON.GROUPID']+ArgSpl ; //新增 安全组到收费项大类配置
	$('#TarCate').combogrid({  
	    panelWidth:350,   
	    panelHeight:260,  
	    idField:'Rowid',   
	    textField:'Desc',
	    editable:false, 
      	rownumbers:true,
      	fit: true,
      	pagination: false,
      	url:TarCateurl,
	    columns:[[   
	        {field:'Rowid',title:'Rowid',width:60},  
	        {field:'Desc',title:'描述',width:100}
	    ]],
		fitColumns: true,
		onLoadSuccess:function(data){
			if(data.rows.length > 0){
				$('#TarCate').combogrid('grid').datagrid('selectRow',0);
			}	
		}
	});
	// 查询条件
	$('#QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [{
				Code: '1',
				Desc: '按拼音',
				selected:true
			},{
				Code: '2',
				Desc: '按代码'
			},{
				Code: '3',
				Desc: '按名称'
			}]
	}); 
}
//医保目录对照grid
function init_dg() { 
	grid=$('#dg').datagrid({
		fit:true,
		striped:true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		cache:true,
		toolbar:'#dgTB',
		pagination:true,
		columns:[[
			{field:'HisCode',title:'收费项代码',width:110},
			{field:'HisDesc',title:'收费项名称',width:120},
			{field:'HISSpecification',title:'HIS规格',width:65},
			{field:'HISDosage',title:'HIS剂型',width:65},
			{field:'Price',title:'单价',width:60,align:'right',formatter:function(val,data,index){
				val = val || 0; // undefined
				return parseFloat(val).toFixed(2);
			}},
			{field:'Cate',title:'大类',width:60},
			{field:'InsuCode',title:'医保编码',width:110},
			{field:'InsuDesc',title:'医保描述',width:120},
			{field:'PZWH',title:'HIS批准文号',width:95},
			{field:'factory',title:'HIS厂家',width:95},
			{field:'InsuGG',title:'医保规格',width:80},
			{field:'InsuDW',title:'医保单位',width:80},
			{field:'InsuSeltPer',title:'自付比例',width:80},
			{field:'DW',title:'单位',width:65,hidden:true},
			{field:'InsuCate',title:'医保大类',width:55,hidden:true},
			{field:'InsuClass',title:'项目等级',width:55,hidden:true},
			{field:'conActDate',title:'生效日期',width:55,hidden:true},
			{field:'index',title:'序号',width:55,hidden:true},
			{field:'LimitFlag',title:'外部代码',width:55,hidden:true},
			{field:'HISPutInTime',title:'HIS录入时间',width:75,hidden:true},
			{field:'SubCate',title:'子类',width:50,hidden:true},
			{field:'Demo',title:'收费项备注',width:100,hidden:true},
			{field:'UserDr',title:'对照人',width:55,hidden:true},
			{field:'ConDate',title:'对照日期',width:65,hidden:true},
			{field:'ConTime',title:'对照时间',width:65,hidden:true},
			{field:'EndDate',title:'结束日期',width:65,hidden:true},
			{field:'ConQty',title:'对照数量',width:55,hidden:true},
			{field:'TarId',title:'TarId',width:60,hidden:true},
			{field:'ConId',title:'ConId',width:10,hidden:true},
			{field:'InsuId',title:'InsuId',width:10,hidden:true},

		]],
        onSelect : function(rowIndex, rowData) {
	        setValueById('InsuCode','')
	        setValueById('InsuDesc','')
	        setValueById('Insurj','')
	        setValueById('PZWH','')
		    ConGridQuery(rowIndex, rowData);
			//-----------tangzf 2019-6-14 自动查出名称类似的医保目录-------------->
			if(getValueById('csconflg'))  //增加是否加载医保目录判断 + DingSH 20200410
			{
				var insuDescObj=document.getElementById('InsuDesc');
				rowData.HisDesc ? insuDescObj.value = rowData.HisDesc.toString().substring(0,5):'';
				QueryINSUTarInfoNew('InsuDesc','3');
			}
			//<--------------------------------------------------------------------
        },
        onUnselect: function(rowIndex, rowData) {
        },
        onBeforeLoad:function(param){
	    	//alert(new Date().getSeconds())
	    },
	    onLoadSuccess:function(data){
		   // alert(new Date().getSeconds())
		}
	});	
}
//医保目录(医保中心)grid
function init_wdg() { 
	var querycol= [[   
		{field:'rowid',title:'rowid',width:60,hidden:true},
		{field:'INTIMxmbm',title:'医保编码',width:110},
		{field:'INTIMxmmc',title:'医保名称',width:120},
		{field:'INTIMxmlb',title:'项目类别',width:55,hidden:true},
		{field:'INTIMjx',title:'剂型',width:65},
		{field:'INTIMgg',title:'规格',width:65},
		{field:'INTIMdw',title:'单位',width:65},
		{field:'INTIMzfbl1',title:'自付比例',width:65},
		{field:'INTIMpzwh',title:'批准文号',width:90},
		{field:'INTIMyf',title:'用法',width:60,hidden:true},
		{field:'INTIMyl',title:'用量',width:60,hidden:true},
		{field:'INTIMspmc',title:'商品名称',width:80,hidden:true},
		{field:'INTIMbzjg',title:'标准价格',width:60,hidden:true},
		{field:'INTIMsjjg',title:'实际价格',width:60,hidden:true},
		{field:'INTIMzgxj',title:'最高限价',width:65},
		{field:'INTIMzfbl2',title:'退休自负比例',width:60,hidden:true},
		{field:'INTIMzfbl3',title:'自付比例3',width:65},
		{field:'INTIMbpxe',title:'报批限额',width:60,hidden:true},
		{field:'INTIMbz',title:'备注',width:100,hidden:true},
		{field:'INTIMsl',title:'数量',width:60,hidden:true},
		{field:'INTIMsfdlbm',title:'大类代码',width:65},
		{field:'INTIMsfdlbmDesc',title:'大类描述',width:65},
		{field:'INTIMsfxmbm',title:'医保类别',width:60,hidden:true},
		{field:'INTIMxmrj',title:'拼音码',width:55,hidden:true},
		{field:'INTIMtxbz',title:'特需项目标志',width:60,hidden:true},
		{field:'INTIMtjdm',title:'统计代码',width:65},
		{field:'INTIMflzb1',title:'是否医保项目',width:60,hidden:true},
		{field:'INTIMflzb2',title:'是否有效',width:60,hidden:true},
		{field:'INTIMflzb3',title:'分类指标3',width:70},
		{field:'INTIMflzb4',title:'分类指标4',width:60,hidden:true},
		{field:'INTIMflzb5',title:'分类指标5',width:60,hidden:true},
		{field:'INTIMflzb6',title:'分类指标6',width:60,hidden:true},
		{field:'INTIMflzb7',title:'分类指标7',width:60,hidden:true},
		{field:'INTIMspmcrj',title:'商品名称别名',width:60,hidden:true},
		{field:'INTIMljzfbz',title:'累计增负标志',width:60,hidden:true},
		{field:'INTIMyyjzjbz',title:'医院增加标志',width:60,hidden:true},
		{field:'INTIMyysmbm',title:'医院三目编码',width:60,hidden:true},
		{field:'INTIMfplb',title:'发票类别',width:60,hidden:true},
		{field:'INTIMDicType',title:'目录类别',width:60,hidden:true},
		{field:'Index',title:'序号',width:60,hidden:true},
		{field:'LimitFlag',title:'限制用药标志',width:60,hidden:true},
		//{field:'INTIMUserDr',title:'项目添加人',width:60},
		{field:'INTIMDate',title:'项目增加日期',width:75,hidden:true},
		{field:'INTIMTime',title:'项目增加时间',width:75,hidden:true},
		//{field:'INTIMADDIP',title:'添加人IP',width:70},
		{field:'INTIMActiveDate',title:'项目生效日期',width:75,hidden:true},
		{field:'INTIMUnique',title:'中心唯一标识码',width:75,hidden:true},
		{field:'INTIMExpiryDate',title:'项目结束日期',width:75,hidden:true}
	]]
	var divgrid=$('#wdg').datagrid({  
		//rownumbers:true,
		data: {"total":0,"rows":''},
		fixRowNumber:true,
		iconCls: 'icon-save',
		striped:true,
		singleSelect: true,
		fit:true,
		columns:querycol,
		toolbar:'#wdgTB',
		frozenColumns:[[
			{
				field: 'Option', title: '对照', width: 50
				,formatter:function(value,rowData,index){
					return "<a href='#' onclick='SaveCon("+index+','+JSON.stringify(rowData)+")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
		]],
		rowStyler: function(index,row){
		},
		pagination:true,
		onSelect : function(rowIndex, rowData) {
			fillConGridEdit(rowIndex,rowData);
		},
		onLoadSuccess:function(data){
		},
		onDblClickRow:function(index,row){
			SaveCon(index,row);
		}	
	
	}); 
	//20180611 DingSH  默认生效日期combobox
	$('#dd').datebox({
			onSelect: function(date){
				var ed = $('#coninfo').datagrid('getEditor', {index:0,field:'conActDate'});
				$(ed.target).datebox('setValue',$('#dd').datebox('getValue'));
			}
		});
	$('#dd').datebox('setValue', GetConDateByConfig());
}
function init_ContraHistory() { 
	$HUI.datagrid('#coninfo',{
		height: 150,
		border:false,
		fitColumns: false,
		singleSelect: true,
		data: [],
		frozenColumns:[[
			{field:'undo',title:'撤销',width:50
				,formatter:function(value,data,row){
					if(data.InsuCode&&data.InsuCode!=""){
						return "<a href='#' onclick='DelCon(\""+row+"\")'>\
						<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png ' border=0/>\
						</a>";
					}
				}
			}
		]],
		columns:[[
			{field:'ConId',title:'ConId',width:5,hidden:true},
			{field:'InsuId',title:'目录详细信息',width:93,formatter:function(value,row,index){
				if(undefined==value){value=""}
				return value == '' ? '' : ('<a href="#" onClick="ShowInsuDetlsbyID(' + value + ',' + index + ',' + 10 + ')">' + value + '</a>');
			}},
			{field:'Insurj',title:'拼音码',width:60},
			{field:'InsuCode',title:'医保编码',width:80},
			{field:'InsuDesc',title:'医保名称',width:150},
			{field:'PZWH',title:'批准文号'},
			{field:'InsuGG',title:'医保规格',width:100},
			{field:'InsuDW',title:'医保单位',width:100},
			{field:'InsuSeltPer',title:'自付比例',width:100},
			{field:'InsuClass',title:'项目等级',width:65},
			{field:'conActDate',title:'对照生效日期',width:100,editor:{type:'datebox'}},
			{field:'TblConUser',title:'对照人',width:65},
			{field:'ExDate',title:'目录失效日期',width:100},
			{field:'InsuCate',title:'发票类别',width:65},
			{field:'DrAddFlag',title:'状态',width:60,hidden:true},
			{field:'DrAddFlagDesc',title:'状态',width:65},
			{field:'ConQty',title:'对照数量',width:65},
			{field:'PatTypeDr',title:'人员类别',width:65},
			{field:'Amount',title:'数量',width:40},
			{field:'DicType',title:'医保类别代码',width:80},
			{field:'ZText',title:'对照备注',width:80},
			{field:'Date',title:'对照日期',width:70},
			{field:'Time',title:'对照时间',width:65},
			{field:'ADDIP',title:'修改机器',width:80},
			{field:'Unique',title:'中心唯一码',width:80},
			{field:'ExpiryDate',title:'对照失效日期',width:100},
			{field:'UpLoadDate',title:'上传日期',width:80},
			{field:'UpLoadTime',title:'上传时间',width:70},
			{field:'DownLoadDate',title:'下载日期',width:80},
			{field:'DownLoadTime',title:'下载时间',width:80},
			{field:'LastModDate',title:'最后修改日期',width:100},
			{field:'LastModTime',title:'最后修改时间',width:100}
		]],
		pageSize:5,
		pageList:[5,10],
		pagination:true,
		onLoadSuccess:function(data){
			/*ConGrid.datagrid('selectRecord', selTarData.ConId);
			$('#windiv').hide();
			ConAct("insertRow");*/ //tangzf2019-6-13
		},
		onDblClickRow:function(){
			DelCon();
		}
	});
	// 面板展开
	$('#south-panel').panel({
    	onCollapse:function(){
			resizeLayout('Collapse');
    	},
    	onExpand:function(){
	    	resizeLayout('Expand');
			
	    }
	});

}

function MSNShow(title,msg,time){
	$.messager.popover({
		msg:msg,
		type:'success',
		timeout:time
	})	
}
/*
 * 对照明细自适应
 */
function resizeLayout(type){
	var height;
	var top ;
	if(type == 'Collapse'){
		height = window.document.body.offsetHeight - 164  - 50 - 35 + 'px'; // page - north - south(collapse) - tabs = dg height
		top =   window.document.body.offsetHeight   - 50 - 35  + 11 +'px'; // dg height + padding10px + north
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#dg').datagrid('resize');
		$('#wdg').datagrid('resize');
	}else  if(type == 'Expand'){
		height = window.document.body.offsetHeight - 164  - 205 - 35 + 'px'; // page - north - south(Expand) - tabs = dg height
		top =   window.document.body.offsetHeight   - 205 - 35  + 12 +'px'; // dg height + padding10px + north
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#dg').datagrid('resize');
		$('#wdg').datagrid('resize');
	}		
}
/*
 * 自动匹配
 */
function autoMatch(type){
	var selectDGRow = $('#dg').datagrid('getSelected');
	if(!selectDGRow || selectDGRow.TarId == ''){
		$.messager.alert('提示','请选择一行数据','info');
		return;	
	}
	switch (type) {
		case 'ApprovalNumber': // 批准文号
			if(selectDGRow.PZWH == '' || selectDGRow.PZWH == '-'){
				$.messager.alert('提示','所选数据的批准文号为空','info');
				return;	
			}
			setValueById('PZWH',selectDGRow.PZWH);
			QueryINSUTarInfoNew('PZWH','2');
			break;
		case 'Desc': // 名称
			setValueById('InsuDesc',selectDGRow.HisDesc);
			QueryINSUTarInfoNew('InsuDesc','3');
			break;
		default:
			break;
	}
}
function selectHospCombHandle(){
	$('#insuType').combogrid('grid').datagrid('reload');
	$('#TarCate').combogrid('grid').datagrid('reload');
	$('#dd').datebox('setValue', GetConDateByConfig());
	Query();
	
}
