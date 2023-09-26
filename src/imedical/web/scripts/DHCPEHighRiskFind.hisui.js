
//名称	DHCPEHighRiskFind.hisui.js
//功能	高危信息查询
//创建	2019.07.05
//创建人  xy

/*******************表达式编辑************************/
var ConditioneditIndex=undefined;
/*function ConditionendEditing(){
			if (ConditioneditIndex == undefined){return true}
			if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
				
				$('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
				
				ConditioneditIndex = undefined;
				return true;
			} else {
				return false;
			}
}
*/
function ConditionendEditing(){
			if (ConditioneditIndex == undefined){return true}
			if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TItemID'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TItem'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TOperator'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TOperatorname'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TSex'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TSexname'] = name;
				
				
				
				$('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
				
				ConditioneditIndex = undefined;
				return true;
			} else {
				return false;
			}
}
/*
function ConditionClickRow(index){
		if (ConditioneditIndex!=index) {
			if (ConditionendEditing()){
				$('#DHCPEEDCondition').datagrid('selectRow',index).datagrid('beginEdit',index);
				ConditioneditIndex = index;
			} else {
				$('#DHCPEEDCondition').datagrid('selectRow',ConditioneditIndex);
			}
		}
}
*/
function ConditionClickRow(index){
		
		if (ConditioneditIndex!=index) {
			if (ConditionendEditing()){
				
				
				$('#DHCPEEDCondition').datagrid('selectRow',index).datagrid('beginEdit',index);
				ConditioneditIndex = index;
				
				
				
			} else {
				$('#DHCPEEDCondition').datagrid('selectRow',ConditioneditIndex);
			}
		}
}
/*******************表达式编辑************************/



$(function(){
		
	
	InitCombobox();
	
	 
	InitHighRiskGrid();
	
	InitHighRiskListGrid();
	
	InitEDConditionGrid();
	
	//查询
    $('#BFind').click(function(){
    	BFind_click();
    });
    
    //电话通知
     $('#BTel').click(function(){
    	BTel_click();
    });
   
    //短信通知
     $('#BSendMessage').click(function(){
    	 BSendMessage_click();
    });
   
    //导出
     $('#BExport').click(function(){
    	BExport_click();
    });
    
    //导出word
    $('#BtnExportWord').click(function(){
    	BtnExportWord_click();
    });
    
     $('#DealRemark').dblclick(function(){
    	DealRemark_DBLClick();
    });
    
    
    //保存
    $('#BSave').click(function(){
    	BSave_click();
    });
    
    
})

/*********************************高危详情start*********************/

 //电话通知
function BTel_click(){
	var PAADM=$("#PAADM").val();
	if (PAADM==""){
		$.messager.alert("提示:","请选择待发送人员","info");
		return false;
	}
	
	var selectrow=$("#HighRiskListGrid").datagrid("getSelected");//获取的是数组，多行数据
	var PAADM=selectrow.TPAADM;
	var EDID=selectrow.TEDID;
	var SourceID=selectrow.TSourceID;
	if (SourceID==""){
		var ID=PAADM+","+EDID;
		var Type="TRC";
	}else{
		var ID=SourceID;
		var Type="THR";
	}
	var RegNo=selectrow.TRegNo;
	var TTel=$.trim($("#Tel").val());
	var MessageTemplate="";
	var MessageTemplate=$("#DealRemark").val();
	
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	
	var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
	if (ret!=0){
		$.messager.alert("提示",ret,"info");
		return false;
	}
	var UserID=session['LOGON.USERID']
	var AllID=GetOtherRecord(PAADM,"T");
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveOtherRecord",AllID,UserID);
	$.messager.alert("提示","处理成功","success");
	BFind_click();
	
	
}
function GetOtherRecord(OldPAADM,OldType)
{
	var objtbl = $("#HighRiskListGrid").datagrid('getRows');
    var rows=objtbl.length
	var ret="";
	for (var i=0;i<rows;i++)
	{
		var PAADM=objtbl[i].TPAADM;
		if (OldPAADM!=PAADM) continue;
		
		var HadSend=objtbl[i].THadSend;
		var EDID=objtbl[i].TEDID;
		var SourceID=objtbl[i].TSourceID;
		
		if (SourceID==""){
			var ID=PAADM+","+EDID;
			var Type=OldType+"RC";
		}else{
			var ID=SourceID;
			var Type=OldType+"HR";
		}
		var OneInfo=ID+"^"+Type;
		if (ret==""){
			ret=OneInfo;
		}else{
			ret=ret+"$"+OneInfo
		}
	}
	return ret;
}

//短信通知
function BSendMessage_click(){
	var PAADM=$("#PAADM").val();
	if (PAADM==""){
		$.messager.alert("提示:","请选择待发送人员","info");
		return false;
	}
	
	var selectrow=$("#HighRiskListGrid").datagrid("getSelected");//获取的是数组，多行数据
	var PAADM=selectrow.TPAADM;
	var EDID=selectrow.TEDID;
	var SourceID=selectrow.TSourceID;
	if (SourceID==""){
		var ID=PAADM+","+EDID;
		var Type="RC";
	}else{
		var ID=SourceID;
		var Type="HR";
	}
	var RegNo=selectrow.TRegNo;
	var TTel=$.trim($("#Tel").val());
	if (TTel==""){
		$.messager.alert("提示:","发送短信电话不能为空","info");
		return false;
	}
	
	if (!isMoveTel(TTel)){
		$.messager.alert("提示:","电话不是移动电话","info");
		return false;
	}
	var MessageTemplate="";
	var MessageTemplate=$("#DealRemark").val();
	if (MessageTemplate==""){
		$.messager.alert("提示:","短信内容不能为空","info");
		return false;
	}
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
   
	if (ret!=0){
		$.messager.alert("提示",ret,"info");
		return false;
	}
	var UserID=session['LOGON.USERID']
	var AllID=GetOtherRecord(PAADM,"");
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveOtherRecord",AllID,UserID);
	
	$.messager.alert("提示","处理成功","success");
	BFind_click();
}

//判断移动电话
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}


//导出
function BExport_click(){
	//alert(EnableLocalWeb+"EnableLocalWeb")
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
try{
	 var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	 var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	var ExportName="DHCPEHighRisk"
	
	xlApp= new ActiveXObject("Excel.Application"); //固定
	xlApp.UserControl = true;
    xlApp.visible = true; //显示
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName);
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
	}
	xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(Row,10)).Borders.LineStyle=1;
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}catch(e)
	{
		alert(e+"^"+e.message);
	}
}
else{
	BPrintNew_click()
}
}
function BPrintNew_click(){
	//alert(11)
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	 var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	var ExportName="DHCPEHighRisk"
	var Str = "(function test(x){"+
	"xlApp= new ActiveXObject('Excel.Application');"+
	"xlApp.UserControl = true;"+
    "xlApp.visible = true;"+
	"xlBook= xlApp.Workbooks.Add('"+Templatefilepath+"');"+
	"xlsheet= xlBook.WorkSheets('Sheet1');"
	var ret=""
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName);
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			if(ret!=""){
				ret+="xlsheet.cells("+Row+","+i+").value='"+DataArr[i]+"';"
				}
			else{
			ret="xlsheet.cells("+Row+","+i+").value='"+DataArr[i]+"';"
			}
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
	}
	var Str=Str+ret+
	"xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells("+Row+",10)).Borders.LineStyle='1';"+
	"xlBook.Close(savechanges = true);"+
	"xlApp.Quit();"+
	"xlApp = null;"+
	"xlsheet = null;"+
	"return 1;}());";
           //alert(Str)
      //以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ; 
	
}
function BPrintWordNew_click()
{
	var wdCharacter=1;
	var Str = "(function test(x){"+
	"var WordApp=new ActiveXObject('Word.Application');"+
	"var wdOrientLandscape = 1;"+
	"WordApp.Application.Visible=true;"+
	"var myDoc=WordApp.Documents.Add();"+
	"WordApp.Selection.ParagraphFormat.Alignment=1;"+
	"WordApp.Selection.Font.Bold=true;"+ 
	"WordApp.Selection.Font.Size=20;"+
	"WordApp.Selection.TypeText('高危信息汇总');"+
	"WordApp.Selection.MoveRight("+wdCharacter+");"+
	"WordApp.Selection.TypeParagraph();"+ 
	"WordApp.Selection.Font.Size=12;"+
	"WordApp.Selection.TypeParagraph();"+ 
	"var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,7);"+
	"myTable.Style='网格型';"+
	"var TableRange;"+
	"myTable.Columns(1).Width=45;"+
	"myTable.Columns(2).Width=35;"+
	"myTable.Columns(3).Width=35;"+
	"myTable.Columns(4).Width=55;"+
	"myTable.Columns(5).Width=80;"+
	"myTable.Columns(6).Width=70;"+
	"myTable.Columns(7).Width=140;"+
	"myTable.Cell(1,1).Range.Text ='姓名';"+
	"myTable.Cell(1,2).Range.Text ='性别';"+
	"myTable.Cell(1,3).Range.Text ='年龄';"+
	"myTable.Cell(1,4).Range.Text ='登记号';"+
	"myTable.Cell(1,5).Range.Text ='单位/VIP等级';"+
	"myTable.Cell(1,6).Range.Text ='电话';"+
	"myTable.Cell(1,7).Range.Text ='高危结果';"
	var ret=""
	var ExportName="DHCPEHighRisk";
	 var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",1,ExportName)
	
	var Row=1;
	while (Info!=""){
		//alert("Info=="+Info);
		var DataArr=Info.split("^");
		var Sort=DataArr[0];
		if (parseInt(Row)>1){
			if(ret!="")
			{
			ret=ret+"myTable.Rows.add();"
			}
			else{
				ret="myTable.Rows.add();"
				
			}
			var DataLength=DataArr.length;
			for (i=1;i<=5;i++){
				if(ret!="")
				{
				ret=ret+"myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i]+"';";
				}
				else{
				ret="myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i]+"';";
				
				}
				
			}
			for (i=6;i<=7;i++){
				if(ret!="")
				{
				ret=ret+"myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i+1]+"';";
				}
				else{
				ret="myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i+1]+"';";
				
				}
				
			}
		}
		if (Sort=="") break;
		 Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName)
		
		Row=Row+1;
	}
	//定义表头格式
	for (i= 0;i<7;i++) {
		
				if(ret!="")
				{
				ret=ret+"myTable.Cell(1,"+i+"+1).Range.font.Size = 11;";
				ret=ret+"myTable.Cell(1,"+i+"+1).Range.Font.Bold = true;";
				}
				else{
				ret="myTable.Cell(1,"+i+"+1).Range.font.Size = 11;";
				ret=ret+"myTable.Cell(1,"+i+"+1).Range.Font.Bold = true;";
				
				}
		
		
	}
	var Str=Str+ret+
	"return 1;}());";
          // alert(Str)
      //以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ; 
	row_count = 0; 
	col_count = 0 
	
}

//导出word
function BtnExportWord_click(){  
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //执行完成之后是否弹出已经生成的word 
	var myDoc=WordApp.Documents.Add();//创建新的空文档 
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//页面方向设置为横向 
	WordApp. Selection.ParagraphFormat.Alignment=1 //1居中对齐,0为居右 
	WordApp. Selection.Font.Bold=true; 
	WordApp. Selection.Font.Size=20 
	WordApp. Selection.TypeText("高危信息汇总"); 
	WordApp. Selection.MoveRight(wdCharacter);　　　　//光标右移字符 
	WordApp.Selection.TypeParagraph() //插入段落 
	WordApp. Selection.Font.Size=12 
	WordApp.Selection.TypeParagraph() //插入段落 
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,7) //1行7列的表格 
	myTable.Style="网格型" 
	var aa = "高危信息汇总" 
	var TableRange;
	
	//设置列宽
	myTable.Columns(1).Width=45;
	myTable.Columns(2).Width=35;
	myTable.Columns(3).Width=35;
	myTable.Columns(4).Width=55;
	myTable.Columns(5).Width=80;
	myTable.Columns(6).Width=70;
	myTable.Columns(7).Width=140;
	
	//输出表头信息
	myTable.Cell(1,1).Range.Text ="姓名";
	myTable.Cell(1,2).Range.Text ="性别";
	myTable.Cell(1,3).Range.Text ="年龄";
	myTable.Cell(1,4).Range.Text ="登记号";
	myTable.Cell(1,5).Range.Text ="单位/VIP等级";
	//myTable.Cell(1,6).Range.Text ="二级部门";
	myTable.Cell(1,6).Range.Text ="电话";
	myTable.Cell(1,7).Range.Text ="高危结果";
	//myTable.Cell(1,9).Range.Text ="建议";
	//myTable.Cell(1,10).Range.Text ="状态";
	
	var ExportName="DHCPEHighRisk";
	 var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",1,ExportName)
	
	var Row=1;
	while (Info!=""){
		//alert("Info=="+Info);
		var DataArr=Info.split("^");
		var Sort=DataArr[0];
		if (parseInt(Row)>1){
			myTable.Rows.add();//新增行
			var DataLength=DataArr.length;
			for (i=1;i<=5;i++){
				myTable.Cell(Row,i).Range.Text=DataArr[i];
			}
			for (i=6;i<=7;i++){
				myTable.Cell(Row,i).Range.Text=DataArr[i+1];
			}
		}
		if (Sort=="") break;
		 Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName)
		
		Row=Row+1;
	}
	//定义表头格式
	for (i= 0;i<7;i++) {
		with (myTable.Cell(1,i+1).Range){
			font.Size = 11;
			Font.Bold = true;
		} 
	}
	row_count = 0; 
	col_count = 0 
	//myDoc.Protect(1)  
	}
	else{
	BPrintWordNew_click()
	
	}
}


function DealRemark_DBLClick(){
	
	var selectrow=$("#HighRiskListGrid").datagrid("getSelected");//获取的是数组，多行数据
	var VIPLevelID=selectrow.TVIPLevelID;
	var Active="1";
	var url='websys.lookup.csp';
	url += "?ID=&CONTEXT=K"+"web.DHCPE.MessageTemplet:FindMessageTemplet";
	url += "&TLUJSF=SetDealRemak"
	url += "&P1="+VIPLevelID
	url += "&P4="+Active
	;
	websys_lu(url,1,'');
	return websys_cancel();

}

function SetDealRemak(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var OldRemak=$("#DealRemark").val();
	$("#DealRemark").val(Arr[1]+";"+OldRemak);
}

function BPriewResult(PAADM){

	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var url="dhcpenewdiagnosis.diagnosis.hisui.csp?EpisodeID="+PAADM+"&MainDoctor="+""+"&OnlyRead="+"Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(url,"_blank",nwin)


}

function CRM_Click(SourceID)
{
	
	var url="dhcpecrminfo.hisui.csp?SourceID="+SourceID;
	websys_lu(url,false,'width=900,height=600,hisui=true,title=随访信息')
}


function InitHighRiskListGrid(){
	
	$HUI.datagrid("#HighRiskListGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"SearchHighRisk",	    
		},
		frozenColumns:[[
			{field:'TRegNo',width:'100',title:'登记号'},
			{field:'TName',width:'100',title:'姓名'},
			
		]],
		columns:[[
		
		 	{field:'TSourceID',title:'EDID',hidden: true},
		 	{field:'TEDID',title:'EDID',hidden: true},
		 	{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TSex',width:'60',title:'性别'},
			{field:'TAge',width:'60',title:'年龄'},
			{field:'TGroup',width:'150',title:'团体'},
			{field:'TDepart',width:'100',title:'部门'},
			{field:'TTel',width:'120',title:'电话'},
			{field:'TEDDesc',width:'200',title:'高危描述'},
			{field:'TEDResult',width:'300',title:'高危结果',
				formatter:function(value,rowData,rowIndex){	
					if(value!=""){
						return "<a href='#'  class='grid-td-text' onclick=BPriewResult("+rowData.TPAADM+"\)>"+value+"</a>";
			
					}
					
	
				}
			},
			{field:'THadSend',width:'100',title:'处理方式'},
			{field:'TSendDate',width:'100',title:'发送日期'},
			{field:'TMessageDetail',title:'短信内容',hidden: true},
			{field:'TCheckDate',width:'100',title:'检查日期'},
			{field:'TVIPLevel',width:'100',title:'VIP等级'},
			{field:'TVIPLevelID',title:'TVIPLevelID',hidden: true},
			{field:'TItem',width:'120',title:'项目'},
			{field:'THHUser',width:'100',title:'上报人'},
			{field:'THHRDate',width:'150',title:'上报时间'},
			{field:'TSendUser',width:'100',title:'通知人'},
			{field:'TAduitUser',width:'100',title:'主检医生'},

				{field:'TCRMFlag',width:70,align:'center',title:'需随访',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'CRM',title:'随访',width:'40',
			formatter:function(value,rowData,rowIndex){
				if((rowData.TSourceID!="")&&(rowData.TCRMFlag=="Y")){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/person.png" title="" border="0" onclick="CRM_Click('+rowData.TSourceID+')"></a>';
			
				}
				}},
			{field:'TCrmFinishFlag',width:70,align:'center',title:'随访完成',
				formatter: function (value, rec, rowIndex) {
					
						if(value=="1"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			

			
		]],
		onSelect: function (rowIndex, rowData) {
			$("#Tel").val(rowData.TTel);
			$("#PAADM").val(rowData.TPAADM);
			$("#DealRemark").val(rowData.TEDResult);		
								
		}
		
			
	})
}
/*********************************高危详情end*********************/



/**************************************高危信息维护 strat***********************************/
//查询 
function BFind_click(){
	var HospID=session['LOGON.HOSPID']
	var StartDate=$("#StartDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	var GroupID=$("#GroupDesc").combogrid('getValue');
	if (($("#GroupDesc").combogrid('getValue')==undefined)||($("#GroupDesc").combogrid('getValue')=="")){var GroupID="";}
	var Name=$("#Name").val();
	
	var iResultFlag="N";
	
	var ResultFlag=$("#ResultFlag").checkbox('getValue');
	if (ResultFlag) {iResultFlag="Y";}
	else{iResultFlag="N";}
	
	
	var EDIDs="";
	var selectrow = $("#HighRiskGrid").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		var EDID=selectrow[i].TEDID;
		if (EDIDs==""){
				EDIDs=EDID;
			}else{
				EDIDs=EDIDs+"^"+EDID;
			}
	}
	if ((EDIDs=="")&&(iResultFlag=="N"))
	{
		$.messager.alert("提示","请选择高危信息","info");
		return false;
	}
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var VIPLevel="";}
	
	var IfSolve=$("#IfSolve").combobox('getValue');
	if (($("#IfSolve").combobox('getValue')==undefined)||($("#IfSolve").combobox('getValue')=="")){var IfSolve="";}
	
	var ContractID=$("#Contract").combogrid('getValue');
	if (($("#Contract").combogrid('getValue')==undefined)||($("#Contract").combogrid('getValue')=="")){var ContractID="";}
	
		
	var iCRMFlag="N";
	var CRMFlag=$("#CRMFlag").checkbox('getValue');
	if(CRMFlag) {iCRMFlag="Y";}

	$('#HighRiskListGrid').datagrid('load', {
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"SearchHighRisk",
			StartDate:StartDate,
			EndDate:EndDate,
			GroupID:GroupID,
			EDIDs:EDIDs,
			ResultFlag:iResultFlag,
			Name:Name,
			IfSolve:IfSolve,
			VIPLevel:VIPLevel,
			ContractID:ContractID,
			CRMFlag:iCRMFlag,
			HospID:HospID
	});
}

function InitHighRiskGrid(){
		$HUI.datagrid("#HighRiskGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"SearchHighRiskED",	    
		},
		frozenColumns:[[
			{title: '选择',field: 'Select',width: 60,checkbox:true},
			{field:'TEDDesc',width:'150',title:'高危描述'},
		]],
		columns:[[
		
		 	{field:'TEDID',title:'EDID',hidden: true},
			{field:'TEDDetail',width:'2000',title:'高危建议'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			$('#express').panel('setTitle','表达式 - '+rowData.TEDDesc);
			$("#ParrefRowId").val(rowData.TEDID);

		   $('#DHCPEEDCondition').datagrid('load', {ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:rowData.TEDID,Type:""});
			ConditionendEditing();
		   
		    
								
		},
		onLoadSuccess:function(data){
			$('#express').panel('setTitle','表达式 - '+rowData.TEDDesc);
			$("#ParrefRowId").val(rowData.TEDID);

			  $('#DHCPEEDCondition').datagrid('load', {ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:rowData.TEDID,Type:""});
			ConditionendEditing();
		   
			
		}
		
			
	})
	
}

/**************************************高危信息维护 end***********************************/



/************************************表达式维护strat***********************************/

function ConditionendEditing(){
			if (ConditioneditIndex == undefined){return true}
			if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TItemID'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TItem'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TOperator'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TOperatorname'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TSex'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TSexname'] = name;
				
				
				
				$('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
				
				ConditioneditIndex = undefined;
				return true;
			} else {
				return false;
			}
}

function BSave_click()
{  
	//$("#DHCPEEDCondition").datagrid('ConditionendEditing', ConditioneditIndex); //最后一行结束行编辑
	//alert(ConditioneditIndex+"ConditioneditIndex")	
	ConditionendEditing();
	var Char_1=String.fromCharCode(1);
	var Express=""
	var rows = $("#DHCPEEDCondition").datagrid("getRows"); 
	
	for(var i=0;i<rows.length;i++){
		
		
		
		var OneRowInfo="",Select="N",PreBracket="",ItemID="",Operator="",ODStandardID="",Reference="",AfterBracket="",Relation="",Sex="N";
		
		ItemID=rows[i].TItemID
		
		if (ItemID=="") break;
		PreBracket=rows[i].TPreBracket
		AfterBracket=rows[i].TAfterBracket
		Relation=rows[i].TRelation
		Operator=rows[i].TOperator
		
		
		Reference=rows[i].TReference
		Sex=rows[i].TSex
		NoBloodFlag=rows[i].TNoBloodFlag
		
		ODStandardID=""
		AgeRange=rows[i].TAgeRange
		
		if(AgeRange!="") {
			if(AgeRange.indexOf("-")==-1)
			{
				$.messager.alert("提示","输入年龄范围格式不正确,应为10-20!","info");
				return false;
			}
			var AgeMin=AgeRange.split("-")[0];
			var AgeMax=AgeRange.split("-")[1];
			if((isNaN(AgeMin))||(isNaN(AgeMax)))
			{
				$.messager.alert("提示","输入年龄不是数字!","info");
				return false;
		
			}
			
		}
		OneRowInfo=PreBracket+"^"+ItemID+"^"+Operator+"^"+ODStandardID+"^"+Reference+"^"+Sex+"^"+AfterBracket+"^"+Relation+"^"+NoBloodFlag+"^"+AgeRange;
		
		if (Express!=""){
			Express=Express+Char_1+OneRowInfo;
		}else{
			Express=OneRowInfo;
		}
		

	}
	
	var iType="ED";
	var ParrefRowId=getValueById("ParrefRowId")
	var ret=tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
		
	if (ret==0){
			
		$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:""}); 
		ConditioneditIndex = undefined;
		return true;	
	}
	
	
	
	
	
}


function loadEDCondition(rowData){
	$('#express').panel('setTitle','表达式 - '+rowData.TEDDesc);
	$('#DHCPEEDCondition').datagrid('load', {
		ClassName:"web.DHCPE.ExcuteExpress",
			QueryName:"FindExpress",
			ParrefRowId:rowData.TEDID,
			Type:""
		
	});
	
	$("#ParrefRowId").val(rowData.TEDID);
	ConditionendEditing();
   ConditioneditIndex = undefined;
		

	
}
function InitEDConditionGrid(){
	
	$HUI.datagrid("#DHCPEEDCondition",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		singleSelect: true,
		selectOnCheck: false,
		onClickRow: ConditionClickRow,
		queryParams:{
			ClassName:"web.DHCPE.ExcuteExpress",
			QueryName:"FindExpress",
			ParrefRowId:"",
			Type:""
		},
		columns:[[
		    {field:'TPreBracket',title:'前置括号',
		    editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'(',text:'('},{id:'((',text:'(('},{id:'(((',text:'((('},{id:'((((',text:'(((('},{id:'(((((',text:'((((('}
						]
						
					}
				}
		    
		    
		    
		    },	
		    {field:'TItemID',title:'项目',width:130,
		    formatter:function(value,row){
						return row.TItem;
					},
					
			editor:{
					type:'combobox',
					options:{
						valueField:'OD_RowId',
						textField:'OD_Desc',
						method:'get',
						//mode:'remote',
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetailA&ResultSetType=array",
						onBeforeLoad:function(param){
							//param.Desc = param.q;
							
							}
						
					}
				}		
					
			/*		
		    editor:{
					type:'combogrid',
					options:{
						
						
						panelWidth:235,
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetail",
						mode:'remote',
						delay:200,
						idField:'OD_RowId',
						textField:'OD_Desc',
						onBeforeLoad:function(param){
							param.Desc = param.q;
						},
						onSelect: function (rowIndex, rowData) {
							var String="^"+rowData.OD_Code+"^"+rowData.OD_RowId
							
							var NorInfo=tkMakeServerCall("web.DHCPE.ODStandard","GetNorInfo",String);
							var obj=document.getElementById("NorInfo");
							if (obj) obj.value=NorInfo;
							
						},
			
						columns:[[
							{field:'OD_RowId',hidden:true},
							{field:'OD_Desc',title:'名称',width:120},
							{field:'OD_Code',title:'编码',width:100}
			
						]]
						
						
						
					}
		    }*/
		    },
		    {field:'TOperator',title:'运算符',width:70,
		    
		    formatter:function(value,row){
						return row.TOperatorname;
					},
		    editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'>',text:'大于'},{id:'>=',text:'大于等于'},{id:'<',text:'小于'},{id:'<=',text:'小于等于'},{id:'[',text:'包含'},{id:"'[",text:'不包含'},{id:'=',text:'等于'},{id:"'=",text:'不等于'}
						]
						
					}
				}
		    },
			{field:'TReference',title:'参考值',
			editor:'text'
			
			},
			{field:'TSex',title:'性别',width:70,
			 formatter:function(value,row){
						return row.TSexname;
					},
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'N',text:'不限'},{id:'M',text:'男'},{id:'F',text:'女'}
						]
						
					}
				}
			},
			{field:'TNoBloodFlag',title:'非血',
			editor:{type:'icheckbox',options:{on:'Y',off:'N'}}
			
			},
			{field:'TAgeRange',title:'年龄',
			editor:'text'
			},
			{field:'TAfterBracket',title:'括号',
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:')',text:')'},{id:'))',text:'))'},{id:')))',text:')))'},{id:'))))',text:'))))'},{id:')))))',text:')))))'}
						]
						
					}
				}},
			{field:'TRelation',title:'关系',width:70,
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'||',text:'或者'},{id:'&&',text:'并且'}
						]
						
					}
				}
			},
			{field:'TAdd',title:'插入一行',width:90,
			editor:{type:'linkbutton',options:{text:'插入一行',handler:function(){
				
			var NewConditioneditIndex=ConditioneditIndex+1;
				ConditionendEditing();
				$('#DHCPEEDCondition').datagrid('insertRow',{
					index: NewConditioneditIndex,
					row: {
						TPreBracket:"",
						TItemID:"",
						TOperator:"",
						TReference:"",
						TSex:"",
						TNoBloodFlag:"",
						TAgeRange:"",
						TAfterBracket:"",
						TRelation:"",
						TAdd:"增加一行",
						TDelete:"删除一行"
						}
					});
				$('#DHCPEEDCondition').datagrid('selectRow',NewConditioneditIndex).datagrid('beginEdit',NewConditioneditIndex);
				ConditioneditIndex = NewConditioneditIndex;
				
				}}}
			
			
			},
			{field:'TDelete',title:'删除一行',width:90,
			editor:{type:'linkbutton',options:{text:'删除一行',handler:function(){
				$('#DHCPEEDCondition').datagrid('deleteRow',ConditioneditIndex);
				ConditioneditIndex = undefined;
				
				}}}
			
			}
		]],
		onAfterEdit:function(rowIndex,rowData,changes){
			
			
	
			
		},
		onSelect: function (rowIndex, rowData) {
			
		}
			
					
	})
		
}

/************************************表达式维护 end***********************************/

function InitCombobox(){
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
	//团体
	var GroupObj = $HUI.combogrid("#GroupDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
				param.GBIDesc=param.q;
			param.ShowPersonGroup="1";

		},
		onShowPanel:function()
		{
			$('#GroupDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TRowId',title:'ID',width:80},
			{field:'TGDesc',title:'团体名称',width:100},	
			{field:'TGStatus',title:'状态',width:80},	
			{field:'TAdmDate',title:'日期',width:100},	
		]]
		});
	
	//合同 
	var ContractObj = $HUI.combogrid("#Contract",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContractNew",
		mode:'remote',
		delay:200,
		idField:'TID',
		textField:'TName',
		onBeforeLoad:function(param){
			param.Name=param.q;
		},
		onShowPanel:function()
		{
			$('#Contract').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TID',title:'ID',width:80},
			{field:'TNo',title:'合同编号',width:100},	
			{field:'TName',title:'合同名称',width:100},	
			{field:'TSignDate',title:'签订日期',width:100},	
		]]
		});
		
	
	//是否处理
	var IfSolveObj = $HUI.combobox("#IfSolve",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'1',text:'已处理'},
            {id:'2',text:'未处理'},
           
        ]

	});	
}

