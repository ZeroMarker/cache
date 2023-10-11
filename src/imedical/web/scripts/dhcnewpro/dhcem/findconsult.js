///qqa
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var CstTypeArr = [{"value":"A","text":$g('平会诊超时')}, {"value":"B","text":$g('急会诊超时')}];
$(function(){
	
	initParams();
	
	initCombobox();
	
	initTable();

	initMethod();
	
})



function initParams(){
	episodeID = getParam("EpisodeID");
}
	
function initCombobox(){
   var LgLocID = session['LOGON.CTLOCID'];
	/// 开始日期
	var Days=Number(FindStDay) //hxy 2021-06-23 st
	if((trim(FindStDay)=="")||(isNaN(FindStDay))){
		Days=-7;
	}else{
		Days=0-Days;
	}
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(Days)); //ed 原：-7 
	/// 结束日期
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	$HUI.combobox("#consultStauts",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
	})
	$HUI.combobox("#consultStauts").setValue(3);
	
	$HUI.combobox("#consultLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	
	$HUI.combobox("#consRLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	$HUI.combobox("#consRLoc").setValue(session['LOGON.CTLOCID']); /// 默认当前登录科室 bianshuai 2018-12-11
    
	if(LgLocID=="95"){
    $("#consRLoc").attr("readOnly",true); 
	}
	
	//会诊性质 hxy 2021-03-18
	$HUI.combobox("#consNature",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstProp&LgHospID="+LgHospID, //hxy 2020-05-29 add LgHospID
		valueField: "itmID", 
		textField: "itmDesc",
		editable:true	
	})
    
   $HUI.combobox("#crsTime",{
		//url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		data:CstTypeArr,
		valueField: "value", 
		textField: "text",
		editable:true
	})
	
	/// 会诊类型 2021-06-23
	$HUI.combobox("#CstType",{ 
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		onLoadSuccess:function(data){
	    }	
	})
}
	
function initTable(){
	
	var columns=[[
		{ field: 'CstID',align: 'center', title: 'CstID',hidden:true},
		{ field: 'CstItmID',align: 'center', title: 'CstItmID',hidden:true},
		//{ field: 'Detail',align: 'center', title: '明细',width:40,formatter:formatDetail},
		{ field: 'Detail',align: 'center', title: '明细',width:40,formatter:closedLoop},
		{ field: 'CstRLoc',align: 'center', title: '申请科室',width:100},
		{ field: 'CstUser',align: 'center', title: '申请人',width:100},
		{ field: 'CstUserJobNum',align: 'center', title: '申请人工号',width:100},
		{ field: 'CstLoc',align: 'center', title: '会诊科室',width:200},
		{ field: 'CareProv',align: 'center', title: '会诊人',width:100},
		{ field: 'CareProvJobNum',align: 'center', title: '会诊人工号',width:100},
		{ field: 'PatName',align: 'center', title: '患者姓名',width:120},
		{ field: 'PatSex',align: 'center', title: '性别',width:60},
		{ field: 'PatNo',align: 'center', title: '登记号',width:120}, //hxy 2021-05-28
		{ field: 'PatMrNo',align: 'center', title: '病案号',width:100}, //hxy 2021-07-09
		{ field: 'PatWard',align: 'center', title: '病区',width:150},
		{ field: 'PatBed',align: 'center', title: '床号',width:80},
		{ field: 'PatDiagDesc',align: 'center', title: '诊断',width:180},
		{ field: 'CstTrePro',align: 'center', title: '简要病史',width:180,formatter:SetCellField}, //hxy 2021-02-02 st 英文换行 //,wordBreak:'break-all'
		{ field: 'CstPurpose',align: 'center', title: '会诊理由及要求',width:180,formatter:SetCellField}, //,wordBreak:'break-all'
		{ field: 'CsOpinion',align: 'center', title: '会诊结论',width:250,formatter:SetCellField}, //ed 加会诊结论特殊字符处理 //,wordBreak:'break-all'
		{ field: 'CstDate',align: 'center', title: '申请日期',width:120},
		{ field: 'CstTime',align: 'center', title: '申请时间',width:120},
		{ field: 'CstNDate',align: 'center', title: '会诊日期',width:120},
		{ field: 'CstNTime',align: 'center', title: '会诊时间',width:120},
		{ field: 'ArrDate',align: 'center', title: '到达日期',width:120}, //hxy 2021-04-02 st
		{ field: 'ArrTime',align: 'center', title: '到达时间',width:120}, //ed
		{ field: 'ComDate',align: 'center', title: '完成日期',width:120}, //hxy 2021-04-13 st
		{ field: 'ComTime',align: 'center', title: '完成时间',width:120}, //ed
		{ field: 'CsSurTime',align: 'center', title: '会诊剩余时间',width:120,formatter:setSurTime}, //hxy 2021-03-18
		{ field: 'CsOverTime',align: 'center', title: '会诊超时时间',width:120}, //hxy 2021-03-19
		{ field: 'CstStatus',align: 'center', title: '当前状态',width:120},
		{ field: 'CstType',align: 'center', title: '会诊类型',width:120}, //hxy 2021-06-23 申请->会诊
		{ field: 'CsProp',align: 'center', title: '会诊性质',width:120}, //hxy 2021-03-18
		{ field: 'CstNPlace',align: 'center', title: '会诊地点',width:100}, //2021-07-09
		{ field: 'REva',align: 'center', title: '申请评价表',width:100,formatter:formatREva},
		{ field: 'CEva',align: 'center', title: '会诊评价表',width:100,formatter:formatCEva},
		{ field: 'AdmType',align: 'center', title: '就诊类型',width:100,formatter:formatType}
	]];
	$HUI.datagrid("#mainLisTable",{
		title:$g('会诊查询'),
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCEMFindConsult&MethodName=GetConsultList",
		queryParams:{
			Params:getParams()
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		autoSizeColumn:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		//nowrap:false, //hxy 2021-07-23 注释
		onClickRow:function(rowIndex, rowData){
			if(rowData.CstStatus=="完成"){
				$("#bt_off").linkbutton("disable");
			}else{
				$("#bt_off").linkbutton("enable");
			}
	    },
	    onDblClickRow: function (rowIndex, rowData) {

        },
        onLoadSuccess:function(data){
			BindTips(); /// 绑定提示消息
		}
	})

}

/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}
	
function initMethod(){
	$('#PatNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur();
        }
    });	
	
}

function commonPrint(){
		
}

function commonExport(){
	runClassMethod("web.DHCEMFindConsult","GetExportDate",{"UserID":UserID},function(retData){
		exportExecl(retData);
	})		
}

function exportExecl(data){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     			/// 结束日期
	if(!data.length){
		$.messager.alert("提示","无导出数据！");
		return;	
	}
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;"+
	"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,33)).MergeCells = true;"+ //合并单元格
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =24;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.Cells(1,1).value='统计时间:"+stDate+"至"+endDate+"';";
	var beginRow=2;
	Str=Str+"objSheet.Cells(2,1).value='申请科室';"+ 
	"objSheet.Cells(2,2).value='申请人';"+
	"objSheet.Cells(2,3).value='申请人工号';"+
	"objSheet.Cells(2,4).value='会诊科室';"+
	"objSheet.Cells(2,5).value='会诊人';"+
	"objSheet.Cells(2,6).value='会诊人工号';"+	 
	"objSheet.Cells(2,7).value='患者姓名';"+ 	
	"objSheet.Cells(2,8).value='性别';"+
	"objSheet.Cells(2,9).value='登记号';"+
	"objSheet.Cells(2,10).value='病案号';"+ 	 
	"objSheet.Cells(2,11).value='病区';"+ 
	"objSheet.Cells(2,12).value='床号';"+ 
	"objSheet.Cells(2,13).value='诊断';"+ 
	"objSheet.Cells(2,14).value='简要病史';"+
	"objSheet.Cells(2,15).value='会诊理由及要求';"+
	"objSheet.Cells(2,16).value='会诊结论';"+ 
	"objSheet.Cells(2,17).value='申请日期';"+ 
	"objSheet.Cells(2,18).value='申请时间';"+
	"objSheet.Cells(2,19).value='会诊日期';"+
	"objSheet.Cells(2,20).value='会诊时间';"+
	"objSheet.Cells(2,21).value='到达日期';"+
	"objSheet.Cells(2,22).value='到达时间';"+
	"objSheet.Cells(2,23).value='完成日期';"+
	"objSheet.Cells(2,24).value='完成时间';"+
	"objSheet.Cells(2,25).value='会诊剩余时间';"+
	"objSheet.Cells(2,26).value='会诊超时时间';"+	 
	"objSheet.Cells(2,27).value='当前状态';"+ 	 
	"objSheet.Cells(2,28).value='会诊类型';"+
	"objSheet.Cells(2,29).value='会诊性质';"+ //hxy 2021-03-18
	"objSheet.Cells(2,30).value='会诊地点';"+
	"objSheet.Cells(2,31).value='申请评价表';"+
	"objSheet.Cells(2,32).value='会诊评价表';"+
	"objSheet.Cells(2,33).value='就诊类型';";
	Str=Str+"objSheet.Columns(17).NumberFormatLocal='@';"; //hxy 2020-04-14
	Str=Str+"objSheet.Columns(3).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(6).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(9).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(10).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(19).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(21).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(23).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(25).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(26).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(31).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(32).NumberFormatLocal='@';";
	for (var i=0;i<data.length;i++){
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+1+").value='"+data[i].CstRLoc+"';"+       
		"objSheet.Cells("+(i+beginRow+1)+","+2+").value='"+data[i].CstUser+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+3+").value='"+data[i].CstUserJobNum+"';"+      
		"objSheet.Cells("+(i+beginRow+1)+","+4+").value='"+data[i].CstLoc+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+5+").value='"+data[i].CareProv+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+6+").value='"+data[i].CareProvJobNum+"';"+  
		"objSheet.Cells("+(i+beginRow+1)+","+7+").value='"+data[i].PatName+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+8+").value='"+data[i].PatSex+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+9+").value='"+data[i].PatNo+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+10+").value='"+data[i].PatMrNo+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+11+").value='"+data[i].PatWard+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+12+").value='"+data[i].PatBed+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+13+").value='"+data[i].PatDiagDesc+"';"+ 
		"objSheet.Cells("+(i+beginRow+1)+","+14+").value='"+data[i].CstTrePro.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 			
		"objSheet.Cells("+(i+beginRow+1)+","+15+").value='"+data[i].CstPurpose.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+16+").value='"+data[i].CsOpinion.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+17+").value='"+data[i].CstDate+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+18+").value='"+data[i].CstTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+19+").value='"+data[i].CstNDate+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+20+").value='"+data[i].CstNTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+21+").value='"+data[i].ArrDate+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+22+").value='"+data[i].ArrTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+23+").value='"+data[i].ComDate+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+24+").value='"+data[i].ComTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+25+").value='"+data[i].CsSurTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+26+").value='"+data[i].CsOverTime+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+27+").value='"+data[i].CstStatus+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+28+").value='"+data[i].CstType+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+29+").value='"+data[i].CsProp+"';"+ //hxy 2021-03-18
		"objSheet.Cells("+(i+beginRow+1)+","+30+").value='"+data[i].CstNPlace+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+31+").value='"+data[i].REva+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+32+").value='"+data[i].CEva+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+33+").value='"+data[i].AdmType+"';";
	}
	var row1=beginRow,row2=data.length+beginRow,c1=1,c2=33;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Range(xlApp.Cells(1,13),xlApp.Cells("+data.length+beginRow+",13)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,14),xlApp.Cells("+data.length+beginRow+",14)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,15),xlApp.Cells("+data.length+beginRow+",15)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,16),xlApp.Cells("+data.length+beginRow+",16)).WrapText = true;"+
	"xlApp.Visible=true;"+
	"objSheet.Columns.AutoFit;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
	"return 1;}());";
	 //以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	return;	
}

/// 查询统计列表
function commonQuery(){
	$HUI.datagrid("#mainLisTable").load({"Params":getParams()});
}

function commonOff(){
	var rows = $HUI.datagrid("#mainLisTable").getSelections();
	if(!rows.length){
		$.messager.alert("提示","请选中一条数据！");
		return;
	}
	var CstID = rows[0].CstID;
	runClassMethod("web.DHCEMConsult","CanCstNo",{"CstID":CstID,"UserID":UserID},function(retString){
		if(retString==0){
			$.messager.alert("提示","作废成功!");
			commonQuery();    //刷新
		}
	},'text')	
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// 开始日期
	var endDate = $HUI.datebox("#endDate").getValue();     			/// 结束日期
	var cstRLocID = $HUI.combobox("#consRLoc").getValue()==undefined?"":$HUI.combobox("#consRLoc").getValue();   //申请科室
	var cstLocID = $HUI.combobox("#consultLoc").getValue()==undefined?"":$HUI.combobox("#consultLoc").getValue();      //接收科室
	var cstStauts = $HUI.combobox("#consultStauts").getValue()==undefined?"":$HUI.combobox("#consultStauts").getValue(); //状态
	var crsTime ="" ; 
	//$HUI.combobox("#crsTime").getValue()==undefined?"":$HUI.combobox("#crsTime").getValue(); //是否超时
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue(); //会诊性质
	var overTime = $HUI.radio("#overTime").getValue()?"Y":"N"; //hxy 2021-03-23
	var PatName=$("#PatName").val();
	var PatNo=$("#PatNo").val();
	var CstType = $HUI.combobox("#CstType").getValue()==undefined?"":$HUI.combobox("#CstType").getValue(); //类型
	var DOCA = $HUI.radio("#DOCA").getValue()?"Y":"N"; //hxy 2022-09-01 st
	var DOCARes = $HUI.radio("#DOCARes").getValue()?"Y":"N"; //ed
	var AdmTypeO=$HUI.checkbox("#O").getValue()?"O":"";
	var AdmTypeE=$HUI.checkbox("#E").getValue()?"E":"";
	var AdmTypeI=$HUI.checkbox("#I").getValue()?"I":"";
	var AdmTypeOEI=AdmTypeO+AdmTypeE+AdmTypeI;
    /// 重新加载会诊列表
	var params = stDate+"^"+endDate+"^"+cstRLocID+"^"+cstLocID+"^"+cstStauts+"^"+UserId+"^"+overTime+"^"+LgHospID+"^"+consNature+"^"+PatName+"^"+PatNo+"^"+CstType;
	var params = params+"^"+DOCA+"^"+DOCARes+"^"+AdmTypeOEI;
	return params;
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


function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\',\''+rowData.TypeCode+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

/// 闭环 bianshuai 2021-07-30
function closedLoop(value, rowData, rowIndex){
	if(HISUIStyleCode==="lite"){ //hxy 2023-02-06
			return '<a href="#" class="icon-write-order" onclick="openClosedLoop(\''+rowData.Oeori+'\',\''+rowData.CstItmID+'\')"></a>';
	}else{
	return '<a href="#" onclick="openClosedLoop(\''+rowData.Oeori+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
	}
}

/// 闭环 bianshuai 2021-07-30
function openClosedLoop(Oeori,CstItmID){
	var iLeft = ($(window).width()-1280)/2; //获得窗口的水平位置;
	var iTop=($(window).height()-640)/2; //获得窗口的垂直位置;
	var lnk = "dhc.orderview.csp?ord="+Oeori+"&ordViewType=CST&ordViewBizId="+CstItmID;
	websys_showModal({
		url: lnk,
		height:640,
		width:1280, //hxy 2021-05-07 890->1280 引用弹窗不可关闭
		left:iLeft,
		top:iTop,
		iconCls:"icon-w-paper",
		title: $g('会诊明细'),
		closed: true,
		onClose:function(){}
	});	
}

function openCstDetail(CstID,CstItmID,TypeCode){
	if(TypeCode=="NUR"){ //hxy 2020-09-18 st
		var lnk = "dhcem.consultnur.csp?CstID="+CstID+"&CstItmID="+CstItmID+"&seeCstType=1"
	}else{//ed
	var lnk = "dhcem.consultwrite.csp?CstID="+CstID+"&CstItmID="+CstItmID+"&seeCstType=1"
	}
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

function formatREva(value, rowData, rowIndex){
	/*var ComTime=rowData.ComTime;
	if(ComTime==""){
		return $g("会诊未完成");
	}*/
	return "<a style='text-decoration:none;' href=\"javascript:void(openREva('"+rowData.CstItmID+"'));\">"+value+"</a>";
}

function formatCEva(value, rowData, rowIndex){
	/*var ComTime=rowData.ComTime;
	if(ComTime==""){
		return $g("会诊未完成");
	}*/
	return "<a style='text-decoration:none;' href=\"javascript:void(openCEva('"+rowData.CstItmID+"'));\">"+value+"</a>";
}

function formatType(value, rowData, rowIndex){
	return "<span>"+$g(value)+"</span>";
}

function openREva(CstItmID){
	var url="dhcem.consapptable.csp?ID="+CstItmID+"&AppTableCode=SHR&SaveMode=R&AppTableTitle=申请评价&seeCstType=1"
	//window.open (url, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	websys_showModal({
		url: url,
		height:450,
		width:650,
		iconCls:"icon-w-paper",
		title: $g('申请评价表'),
		closed: true,
		onClose:function(){}
	});	
	return false;
}

function openCEva(CstItmID){
	var url="dhcem.consapptable.csp?ID="+CstItmID+"&AppTableCode=SHP&SaveMode=C&AppTableTitle=会诊评价&seeCstType=1";
	//window.open (url, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	websys_showModal({
		url: url,
		height:450,
		width:650,
		iconCls:"icon-w-paper",
		title: $g('会诊评价表'),
		closed: true,
		onClose:function(){}
	});	
	return false;	
}

///补零方法
function RegNoBlur()
{
	var i;
    var regno=$('#PatNo').val();
    var oldLen=regno.length;
    if (oldLen==8) return;
	if (regno!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    {
	    	regno="0"+regno 
	    }
	}
    $("#PatNo").val(regno);
}

/// 绑定提示栏
function BindTips(){
	
	var html='<div id="tip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// 鼠标离开
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// 超时时的翻译
function setSurTime(value, rowData, rowIndex){	
	if (rowData.CsSurTime == "超时"){
		rowData.CsSurTime = $g("超时");
	}
	var htmlstr= '<span>'+ rowData.CsSurTime +'</span>';
	return htmlstr;
}


