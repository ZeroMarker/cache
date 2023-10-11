///qqa
var exportShowDatail="";
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID //hxy 2020-05-29
$(function(){
	
	initParams();
	
	initCombobox();
	
	initTable();
	
	initMethod ();
		
})



function initParams(){
	Model = getParam("Model");   //模式：1：查看自己，2：查看所有；默认查看自己
}
	
function initCombobox(){
	$HUI.combobox("#statisType",{
		valueField: "value", 
		textField: "text",
		editable:false, //hxy 2021-04-19 true->false 做为必选，不可为空
		data:[
			{
				"value":1,
				"text":$g("按照申请科室")
			},{
				"value":2,
				"text":$g("按照接收科室")
			},
		]
	})
	
	$HUI.combobox("#consultType",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+session['LOGON.HOSPID'],
		valueField: "value", 
		textField: "text",
		editable:true,
		onLoadSuccess:function(data){
	        var data = $HUI.combobox("#consultType").getData();
	        var CstType = $HUI.combobox("#consultType").getValue();
	        if(data.length>0){
			    $HUI.combobox("#consultType").select(data[0].value);
			    $HUI.datagrid("#consultStatisTable").load({"Params":getParams()});
		    }
	    }
		
	})
	
	$HUI.combobox("#statisType").setValue(1);      //默认为本人发送
	
	$HUI.combobox("#consNature",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstProp&LgHospID="+LgHospID, //hxy 2020-05-29 add LgHospID
		valueField: "itmID", 
		textField: "itmDesc",
		editable:true
		
	})
	
	$HUI.combobox("#consLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	if(Model==2){
		$HUI.combobox("#consLoc").enable();
	}else{
		$HUI.combobox("#consLoc").setValue(LocID);
	}
	
	/// 开始日期
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(-7));
	/// 结束日期
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
}
	
function initTable(){
	var columns=[[
		{ field: 'CstRLoc',align: '', title: '申请科室',width:50},
		{ field: 'CsLocDesc',align: '', title: '会诊科室',width:250,hidden:true},
		{ field: 'CareProvTpDesc',align: '', title: '会诊职称',width:50},
		{ field: 'CsUserDesc',align: '', title: '会诊人',width:50},
		{ field: 'Number',align: 'center', title: '会诊次数',width:50,formatter:formNumber},
		{ field: 'OverTimeNumber',align: 'center', title: '超时次数',width:50,formatter:formOverTimeNumber},
		{ field: 'RefNumber',align: 'center', title: '拒收会诊次数',width:50,formatter:formRefNumber}, //hxy 2021-04-06 st
		{ field: 'RejNumber',align: 'center', title: '驳回会诊次数',width:50,formatter:formRejNumber}, //ed
		{ field: 'OrdAllPress',align: 'center', title: '会诊金额',width:50},
		{ field: 'ConsItms',align: '', title: 'Itms',width:50,hidden:true}
	]];
	$HUI.datagrid("#consultStatisTable",{
		title:$g('会诊统计'), //hxy 2023-02-06 st
		iconCls:'icon-paper',
		toolbar:"#toolbar",
		headerCls:'panel-header-gray', //ed
		url:LINK_CSP+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetConsultList",
		queryParams:{
			Params:getParams()
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:false,
		onClickRow:function(rowIndex, rowData){

	    },
	    onDblClickRow: function (rowIndex, rowData) {

        }
	})
	
	var columns=[[
		{ field: 'CstRLoc',align: 'left', title: '申请科室',width:90},
		{ field: 'CstRUser',align: 'left', title: '申请人',width:50,hidden:true},
		{ field: 'CstLoc',align: 'left', title: '会诊科室',width:90},
		{ field: 'CstRDate',align: 'left', title: '申请日期',width:90},
		{ field: 'CstRTime',align: 'left', title: '申请时间',width:70},
		{ field: 'ArrDate',align: 'left', title: '到达日期',width:90}, //hxy 2021-04-03 st
		{ field: 'ArrTime',align: 'left', title: '到达时间',width:70}, //ed
		{ field: 'CmpDate',align: 'left', title: '完成日期',width:90},
		{ field: 'CmpTime',align: 'left', title: '完成时间',width:70},
		{ field: 'OverTimeVal',align: 'left', title: '超时时长',width:70}, //hxy 2021-04-03
		{ field: 'PatName',align: 'left', title: '病人姓名',width:70},
		{ field: 'CstType',align: 'left', title: '会诊类型',width:70},
		//{ field: 'Detail',align: 'center', title: '明细',width:60,formatter:formatDetail},
		{ field: 'Detail',align: 'left', title: '明细',width:40,formatter:closedLoop},
		{ field: 'EpisodeID',align: 'left', title: '就诊号',width:60},
		{ field: 'RefUser',align: 'left', title: '拒收人',width:60,hidden:true}, //hxy 2021-05-06 st
		{ field: 'RefRea',align: 'left', title: '拒收原因',width:120,hidden:true},
		{ field: 'RejUser',align: 'left', title: '驳回人',width:60,hidden:true},
		{ field: 'RejRea',align: 'left', title: '驳回原因',width:120,hidden:true} //ed
	]];
	
	///会诊明细
	$HUI.datagrid("#consDetailTable",{
		bodyCls:'panel-header-gray',//hxy 2023-02-06
		url:LINK_CSP+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetConsultDetailList",
		queryParams:{
			Params:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:false, //hxy 2021-05-06 true->false
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true
	})
	
}
	
function initMethod(){
	
}

/// 查询统计列表
function commonQuery(){
	var TypeDesc = $HUI.combobox("#consultType").getText()==undefined?"":$HUI.combobox("#consultType").getText(); //2020-09-22 st
	if(TypeDesc.indexOf("院际")>-1){
		$.messager.alert("提示","院际会诊不纳入该统计范围！");
		$('#consultStatisTable').datagrid('loadData', { total: 0, rows: [] });  
		return;	
	} //ed
	$HUI.datagrid("#consultStatisTable").load({"Params":getParams()});
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();
	if(statisType==1){
		$('#consultStatisTable').datagrid('showColumn','CstRLoc'); 
		$('#consultStatisTable').datagrid('hideColumn','CsLocDesc');
	}else if(statisType==2){
		$('#consultStatisTable').datagrid('showColumn','CsLocDesc'); 	
		$('#consultStatisTable').datagrid('hideColumn','CstRLoc');
	}
	if(!$HUI.radio("#showDetail").getValue()){ //checkbox
		$('#consultStatisTable').datagrid('hideColumn','CsUserDesc'); 	
	}
	if($HUI.radio("#showDetail").getValue()){ //checkbox
		$('#consultStatisTable').datagrid('showColumn','CsUserDesc'); 	
	}
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); /// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     /// 结束日期
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();    	 /// 状态
	var consultType = $HUI.combobox("#consultType").getValue()==undefined?"":$HUI.combobox("#consultType").getValue();
	var showDetail = $HUI.radio("#showDetail").getValue()?"Y":"N"; //checkbox
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue();
	exportShowDatail = showDetail;
	if(Model=="2") LocID=""
	LocID = $HUI.combobox("#consLoc").getValue()==undefined?"":$HUI.combobox("#consLoc").getValue();
    /// 重新加载会诊列表
	var params = stDate+"^"+endDate+"^"+statisType+"^"+showDetail+"^"+LocID+"^"+consultType+"^"+consNature+"^"+LgHospID;
	return params;
}

function commonExport(){
	var datas = $('#consultStatisTable').datagrid("getData");
	exportData(datas.rows);
}

function formNumber(value, rowData, rowIndex){
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.ConsItms+'\')">&nbsp;'+value+'&nbsp;</a>'; //underline
}

function formOverTimeNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.OverTimeItmIDs+'\')">&nbsp;'+value+'&nbsp;</a>';

}

function formRefNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.RefItms+'\',25)">&nbsp;'+value+'&nbsp;</a>';
}

function formRejNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.RejItms+'\',22)">&nbsp;'+value+'&nbsp;</a>';
}

function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\',\''+rowData.TypeCode+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

function openCstDetail(cstID,cstItmID,TypeCode){
	OpenConsWin();
	if(TypeCode=="NUR"){ //hxy 2020-09-18 st
		if ('undefined'!==typeof websys_getMWToken){
			$("#newWinFrame").attr("src","dhcem.consultnur.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1"+"&MWToken="+websys_getMWToken());
		}else{
		$("#newWinFrame").attr("src","dhcem.consultnur.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1");
		}
	}else{ //ed
		if ('undefined'!==typeof websys_getMWToken){
			$("#newWinFrame").attr("src","dhcem.consultwrite.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1"+"&MWToken="+websys_getMWToken());
		}else{
		$("#newWinFrame").attr("src","dhcem.consultwrite.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1");
		}
	}
	return;
}

/// 闭环 bianshuai 2021-07-30
function closedLoop(value, rowData, rowIndex){
	//return '<a href="#" onclick="openClosedLoop(\''+rowData.Oeori+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
	return '<a href="#" onclick="openClosedLoop(\''+rowData.Oeori+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

/// 闭环 bianshuai 2021-07-30
function openClosedLoop(Oeori,CstItmID){

	//var lnk = "dhc.orderview.csp?ord="+Oeori; //hxy 2022-07-05 st
	var lnk = "dhc.orderview.csp?ord="+Oeori+"&ordViewType=CST&ordViewBizId="+CstItmID; //ed
	websys_showModal({
		url: lnk,
		height:640,
		width:1280, //hxy 2021-05-07 890->1280 引用弹窗不可关闭
		iconCls:"icon-w-paper",
		title: $g('会诊明细'),
		closed: true,
		onClose:function(){}
	});	
}

///查询会诊明细
function ShowConsultDetail(value,code){
	$('#consDetailTable').datagrid('hideColumn','RefUser'); //hxy 2021-05-06 st
	$('#consDetailTable').datagrid('hideColumn','RefRea');
	$('#consDetailTable').datagrid('hideColumn','RejUser'); 	
	$('#consDetailTable').datagrid('hideColumn','RejRea');
	if(code==25){
		$('#consDetailTable').datagrid('showColumn','RefUser'); 	
		$('#consDetailTable').datagrid('showColumn','RefRea');
	}else if(code==22){
		$('#consDetailTable').datagrid('showColumn','RejUser'); 	
		$('#consDetailTable').datagrid('showColumn','RejRea');
	} //ed
	
	$HUI.datagrid("#consDetailTable").load({"Params":value});	
	$HUI.window("#consDetailWin").open();
}

function exportData(datas){
	var stDate = $HUI.datebox("#stDate").getValue(); /// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     /// 结束日期
	var CstType = $HUI.combobox("#consultType").getText(); ///会诊类型 hxy 2021-04-15 st
	var Nature = $HUI.combobox("#consNature").getText();   ///会诊性质
	var Note="";
	if((CstType!="")&&(CstType!=undefined)){
		CstType="会诊类型:"+CstType+"  ";
	}
	if((Nature!="")&&(Nature!=undefined)){
		Nature="会诊性质:"+Nature+"  ";
	}
	Note=CstType+Nature; //ed

	if(datas.length==0){
		$.messager.alert("提示","无需导出数据！");
		return;	
	}
	
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;";
	var beginRow=2;
	if(Note!=""){beginRow=3;} //hxy 2021-04-15
	var colNuber=0;;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+((datas[i].CstRLoc)||(datas[i].CsLocDesc))+"';"+ //申请科室
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].CareProvTpDesc+"';";			  //会诊职称
		if(exportShowDatail=="Y"){
			Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].CsUserDesc+"';"	 //会诊医师
		}
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].Number+"';"+	//会诊次数
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].OverTimeNumber+"';"+	//超时次数
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].RefNumber+"';"+	        //拒收会诊次数 hxy 2021-04-19 st
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].RejNumber+"';"+	        //驳回会诊次数 ed
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].OrdAllPress+"';";	 	//会诊金额		
	}
	
	colNuber=0;
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='"+(typeof datas[0].CstRLoc != "undefined"?"申请科室":"会诊科室")+"';"+    //申请科室
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊职称';"; 	 //会诊职称
	if(exportShowDatail=="Y"){
		Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊人';";	 //会诊医师
	}
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊次数';"+	//会诊次数
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='超时次数';"+			//超时次数	
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='拒收会诊次数';"+	    //拒收会诊次数 hxy 2021-04-19 st
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='驳回会诊次数';"+		//驳回会诊次数 ed
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='会诊金额';"	 		//会诊金额	
	
	Str=Str+"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,"+colNuber+")).MergeCells = true;"+ //合并单元格
	"objSheet.Cells(1,1).value= '统计时间:"+stDate+"至"+endDate+"';";
	
	if(Note!=""){ //hxy 2021-04-15
		Str=Str+"xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,"+colNuber+")).MergeCells = true;"+ //合并单元格
		"objSheet.Cells(2,1).value= '"+Note+"';";
	}
	Str=Str+"objSheet.Columns.AutoFit;"; //hxy 2021-04-19
	
	var row1=beginRow,row2=datas.length+beginRow,c1=1,c2=colNuber;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Visible=true;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
    "return 1;}());";
    //以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	return;
}


function exportDataOld(datas){
	var stDate = $HUI.datebox("#stDate").getValue(); /// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     /// 结束日期
	if(datas.length==0){
		$.messager.alert("提示","无需导出数据！");
		return;	
	}
	//var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	//var Template = path+"DHCEM_Consult_Statis.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add();
	var objSheet = xlBook.ActiveSheet;
	var beginRow=2;	
	var colNuber=0;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=(datas[i].CstRLoc)||(datas[i].CsLocDesc); //申请科室
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].CareProvTpDesc; //会诊职称
		if(exportShowDatail=="Y"){
			objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].CsUserDesc;	 //会诊医师
		}
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].Number;		     //会诊次数
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].OverTimeNumber;	 //超时次数
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].OrdAllPress;	 //会诊金额		
	}
	
	colNuber=0;
	objSheet.Cells(beginRow,colNuber+=1).value=(typeof datas[0].CstRLoc != "undefined"?"申请科室":"会诊科室");    //申请科室
	objSheet.Cells(beginRow,colNuber+=1).value="会诊职称"; 	 //会诊职称
	if(exportShowDatail=="Y"){
		objSheet.Cells(beginRow,colNuber+=1).value="会诊人";	 //会诊医师
	}
	objSheet.Cells(beginRow,colNuber+=1).value="会诊次数";	 //会诊次数
	objSheet.Cells(beginRow,colNuber+=1).value="超时次数";	 //超时次数	
	objSheet.Cells(beginRow,colNuber+=1).value="会诊金额";	 //会诊金额	
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,colNuber)).MergeCells = true; //合并单元格
	objSheet.Cells(1,1).value= "统计时间:"+stDate+"至"+endDate
	gridlist(objSheet,beginRow,datas.length+beginRow,1,colNuber);
	
	xlApp.Visible=true;
	xlApp=null;
	xlBook=null;
	objSheet=null;	
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

/// 打卡MDT填写页面
function OpenConsWin(){
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true",
		iconCls:'icon-w-card'
	};
	new WindowUX($g('会诊明细查询'), 'ConsWin', '930', '560', option).Init();
}


/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}