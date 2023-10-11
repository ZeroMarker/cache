
///modified by ZY 20221115 3081237
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};
var fileview = $.extend({}, $.fn.datagrid.defaults.view, { onAfterRender: function (target) { isselectItem(); } });
var selectItems = new Array();
var columns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','N');
var frozencolumns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','Y');
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	defindTitleStyle();
	initButton(); //按钮初始化
	//initButtonWidth();  //add by lmm 2019-10-23 1060991
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	if(vElementID=="EquipType")
	{
		setElement("StatCatDR","")
		setElement("StatCat","")
	}
}
$HUI.datagrid("#DHCEQEquipFacilityFind",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.EM.BUSEquip",
        QueryName:"GetEquipList",
        Data:GetParams()+"^InitFlag=Y",	//modified ZY20221226 bug:3081274
        Ejob:getElementValue("Job"),    //add by yh 2020-01-15
        ReadOnly:""
    },
    border:false,
    fit:true,
	fitColumns:false,		// MZY0153	3206641		2023-02-20
    //singleSelect:true,	//modified by ZY 20221115 3081237
    rownumbers: true,  //如果为true，则显示一个行号列
	columns:columns, 
	frozenColumns:frozencolumns,
	pagination:true,
	pageSize:25,
	pageNumber:1,
	pageList:[25,50,75,100],
	toolbar:[{
				iconCls: 'icon-print',
            	text:'批量打印条码',          
            	handler: function(){
                	BPrintBar_Clicked();
            }},
            {
                iconCls: 'icon-batch-cfg',
                text:'导出列设置',
                handler: function(){
                     BColSet_Click();
            }},    //modify by lmm 2020-04-03
            {
            	iconCls: 'icon-export',
            	text:'导出',
            	handler: function(){
                	BSaveExcel_Clicked();
            }},    //modify by zc0125 2022-11-09 增加导入按钮 begin
            {
            	iconCls: 'icon-import',
            	text:'导入',
            	handler: function(){
                	BImport_Click();
            }}],	//modify by zc0125 2022-11-09 增加导入按钮 end
	//modify by cjt 20220925 需求号2801297
	onDblClickRow:function(rowIndex, rowData)
	{	
		if (rowData.TRowID!="")
		{
			if (getElementValue("ClassFlag")=="N")
			{
				var str="dhceq.em.equipfacility.csp?RowID="+rowData.TRowID+"&ReadOnly=";
				showWindow(str,"简易台账","","586px","icon-w-paper","modal","","","large")     //MZY0157	3220853		2023-03-29
			}
			else
			{
				var str="dhceq.em.equipclass.csp?RowID="+rowData.TRowID+"&ReadOnly=";
				showWindow(str,"泛类台账","655px","282px","icon-w-paper","modal","","","small")     // MZY0151	2023-02-01  //modified by txr 20230324
			}
		}
	},
	onLoadSuccess: function (data) {
		//var lable_innerText='总数量:'+totalSum("DHCEQEquipFacilityFind","TQuantity")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQEquipFacilityFind","TOriginalFee").toFixed(2)
		//$("#sumTotal").html(lable_innerText);
		InitToolbarForAmountInfo();  //add by wy 2022-3-31 WY0099
		//add by wy 2022-4-15  屏蔽不显示的列
		if (getElementValue("ClassFlag")=="Y") {
			var fields = $("#DHCEQEquipFacilityFind").datagrid('getColumnFields');
            for (var i = 0; i < fields.length; i++) {
	            
                var option = $("#DHCEQEquipFacilityFind").datagrid('getColumnOption', fields[i]);
	           $('#DHCEQEquipFacilityFind').datagrid('hideColumn',option.field );

            }
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TCommonName')
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TEquipType')
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TStatCat')
		$('#DHCEQEquipFacilityFind').datagrid('showColumn','TEquiCat')
		$('#DHCEQEquipFacilityFind').datagrid('hideColumn','TNo')
		}


    },
    //modified by ZY 20221115 3081237
    onClickRow:function(rowIndex,rowData){addselectItem(rowIndex,rowData);},
});
// add by wy 2022-3-31 WY0099 简易台帐明细菜单栏中显示合计信息
function InitToolbarForAmountInfo() {
    
    //modified by ZY 20221115 3081219 修改合计行取值位置
    //var Data = tkMakeServerCall("web.DHCEQEquipSave","GetEquipSumInfo",'',getElementValue("Job"),0);   //Modified by JYP0019 台帐添加job对多用户进行限制 //add by wy 2022-3-31 WY0099 增加参数vType
    var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'EquipList','',getElementValue("Job"),'','1'); 
    $("#sumTotal").html(Data);  
    
    //var Data = tkMakeServerCall("web.DHCEQEquipSave","GetEquipSumInfo",'',getElementValue("Job"),1);   //Modified by JYP0019 台帐添加job对多用户进行限制
    //$("#sumTotal").html(Data);  
}
///打印条码
function BPrintBar_Clicked()
{
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode&Job='+getElementValue("Job");  //modified by csj 2020-03-01 需求号：1206002
    showWindow(url,"批量打印条码","","7row","icon-w-paper","modal","","","small")  //modify by lmm 2020-06-04 UI
}

///新增事件
function BAdd_Clicked()
{
    //add by wy 2022-4-15 分开范类设备，简易设备
	if (getElementValue("ClassFlag")=="N")
	{
		var url='dhceq.em.equipfacility.csp?RowID=';
		showWindow(url,"简易台账","","586px","icon-w-paper","modal","","","large")     //MZY0157	3220853		2023-03-29
	}
	else
	{
		var url='dhceq.em.equipclass.csp?RowID=';
		showWindow(url,"泛类台帐","655px","280px","icon-w-paper","modal","","","small")     // MZY0151	2023-02-01   //modified by txr 20230324
	}
}

///查询事件
function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQEquipFacilityFind",{
		url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",
	        QueryName:"GetEquipList",
	        Data:GetParams(),
	       Ejob:getElementValue("Job"),//add by yh 2020-01-15 
	        ReadOnly:""
	    }
	});
}
function BSaveExcel_Clicked()
{
    vData=GetParams();
    ///modified by ZY 20221115 bug:3081207
    PrintDHCEQEquipNew("Equip",1,getElementValue("Job"),vData,"EquipList",100);  //modify by lmm 2020-05-26 1333444
}
function BColSet_Click() //导出数据列设置
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)     //modify by lmm 2020-06-02 UI
}
function GetParams()
{
	var Params="^No="+getElementValue("No");
	Params=Params+"^Name="+getElementValue("Name");
	Params=Params+"^UseLocDR="+getElementValue("UseLocDR");
	Params=Params+"^Code="+getElementValue("Code");
	Params=Params+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	Params=Params+"^MinValue="+getElementValue("MinValue");
	Params=Params+"^MaxValue="+getElementValue("MaxValue");
	Params=Params+"^BeginInStockDate="+getElementValue("BeginInStockDate");
	Params=Params+"^EndInStockDate="+getElementValue("EndInStockDate");
	Params=Params+"^FacilityFlag="+getElementValue("FacilityFlag");
	Params=Params+"^IsDisused=N";
	Params=Params+"^IsOut=N";
	Params=Params+"^ConditionLimit=1";  ///Modefied by ZC0081 2020-09-07 添加ConditionLimit解决名称不能检索问题
	Params=Params+"^ClassFlag="+getElementValue("ClassFlag");  //add by wy 2022-4-15 泛类标记
	return Params;
}
function  PrintDHCEQEquip(TableName,SaveOrPrint,job,vData,TempNode,GetRowsPerTime)
{
	window.clipboardData.clearData();
	if (!TempNode)
	{
		TempNode="";
	} 
	var num=tkMakeServerCall("web.DHCEQEquipSave","GetNum","",job)  // 测试组需求修改 modify by jyp 20200212    JYP0020  需求号：1188971
	
	if (num<1) {alertShow("表没值")}
	else
	{
     try {
	     if (SaveOrPrint=="1")
	     {
		     var FileName=GetFileName();
		     if (FileName=="") {return;}
	     }
      	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");

		var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","2","",TableName); //用户级设置
		if (colsets=="")
		{
			var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","1","",TableName); //安全组级设置
			if (colsets=="")
			{
				var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","0","",TableName); //系统设置
			}
		}
		if (colsets=="")
		{
			alertShow("导出数据列未设置!")
			return
		}
		var colsetlist=colsets.split("&");
		var colname=new Array()
		var colcaption=new Array()
		var colposition=new Array()
		var colformat=new Array()
		var colwidth=new Array()
		var cols=colsetlist.length
		for (i=0;i<cols;i++)
		{
			var colsetinfo=colsetlist[i].split("^");
			colcaption[i]=colsetinfo[1];
			colname[i]=colsetinfo[2];
			colposition[i]=colsetinfo[3];
			colformat[i]=colsetinfo[4];
			colwidth[i]=colsetinfo[5];
		}
			
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBlank.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    //获取表头信息
	    var TitleInfo=tkMakeServerCall("web.DHCEQCommon","GetTitleInfo","Equip");
	    var TitleRow=0
	    if (TitleInfo!="")
	    {
		    TitleInfo=TitleInfo.split("@")
		    TitleRow=TitleInfo[0]*1
		    var ParaInfo=TitleInfo[1].split("&")
		    for (i=1;i<=TitleRow;i++)
		    {
			    xlsheet.Range(xlsheet.Cells(i,1),xlsheet.Cells(i,cols)).MergeCells = true;
			    xlsheet.cells(i,1)=ParaInfo[i-1]
		    }
		    if (TitleRow>0)
		    {
			    xlsheet.cells(1,1).Font.Bold = true;
			    xlsheet.cells(1,1).Font.Size = 20;
			    xlsheet.cells(1,1).EntireRow.AutoFit
			    xlsheet.cells(1,1).HorizontalAlignment = 3;
			    xlsheet.PageSetup.PrintTitleRows ="$1:$"+(TitleRow+1)
		    }
		    ParameterReplace(xlsheet,vData)
	    }
	    else
	    {
		    xlsheet.PageSetup.PrintTitleRows ="$1:$1"
	    }
	    xlsheet.PageSetup.LeftFooter="制表人:"+curUserName
	    xlsheet.PageSetup.RightFooter="第&P页(共&N页)"
	    //
	    for (i=0;i<cols;i++)
	    {
		    xlsheet.cells(TitleRow+1,i+1)=colcaption[i];
	    	if (colwidth[i]!="")
	    	{
		    	xlsheet.Columns(i+1).ColumnWidth =colwidth[i];
	    	}
		}
	    num=parseFloat(num);
	    ///优化台帐导出效率?增加参数每次获取行数信息
	    var splitChar=String.fromCharCode(2);
	    var endRow;
	    
	    for (Row=1;Row<=num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
		 	
		 	///优化台帐导出效率?增加参数每次获取行数信息
		 	if (!GetRowsPerTime)
		 	{	endRow=Row;	}
		 	else
			{	endRow=Row+GetRowsPerTime-1;	}
			if (endRow>num) endRow=num;
			var rowsCount=endRow-Row+1;
			var strConcat="";
			var strArr=new Array();
			var beginRow=Row;
			var fieldVal;
		
		 	if (!GetRowsPerTime)
		 	{
			 	var str=tkMakeServerCall("web.DHCEQEquipSave","GetList",TempNode,job,Row);
		 	}
		 	else
		 	{
				var str=tkMakeServerCall("web.DHCEQEquipSave","GetList",TempNode,job,Row,rowsCount)
		 	}
			var rowVal=str.split(splitChar);
			
			for (j=0;j<rowsCount;j++)
			{			
				var List=rowVal[j].split("^");
		    	var strLine=""
		    	for (i=1;i<=cols;i++)
		    	{
			    	var position=colposition[i-1];
			    	if (position>0)
			    	{	position=position-1;}
			    	else
			    	{	position=0}
			    	
			    	fieldVal=List[position];
			    	if (colformat[i-1]==2)
				    {
					   	if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "0.00_ ";
					}
					else if (colformat[i-1]==4)
					{
					    if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "@";
					}
				    else if (colformat[i-1]!="")
				    {
				    	fieldVal=ColFormat(fieldVal,colformat[i-1]);
				    }
				    fieldVal=fieldVal.replace(/\t/g," ");
				    fieldVal=fieldVal.replace(/\r\n/g," ");
				    strLine=strLine+fieldVal;
				    if (i<cols) strLine=strLine+"\t";
		    	}
		    	if (j!=0) strLine="\r"+strLine;
		    	strArr.push(strLine);
		    	if (Row<endRow) Row++;
			}
	     	strConcat=String.prototype.concat.apply("",strArr);
	     	xlsheet.Cells(beginRow+TitleRow+1,1).Select();
		 	window.clipboardData.setData("Text",strConcat);
		 	xlsheet.Paste();
	     }
	     
	     if (SaveOrPrint=="1")
	     {
		     xlBook.SaveAs(FileName);
	     }
	     else
	     {
		     xlsheet.printout; //打印输出
	     }
	    
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    if (SaveOrPrint=="1")
	    {
		    alertShow("导出完成!");
	    }
	    } 
	catch(e)
	 {
		alertShow(e.message);
	 }
	}
}

function ParameterReplace(xlsheet,vData)
{
	var Find=xlsheet.cells.find("[Hospital]")
	var Hospital=tkMakeServerCall("web.DHCEQCommon","GetHospitalDesc")
	if (Find!=null) {xlsheet.cells.replace("[Hospital]",Hospital)}
	
	var vInfo=vData.split("^")
	var vCount=vInfo.length
	var vCurInfo=""
	for (var i=1;i<vCount;i++)
	{
		vCurInfo=vInfo[i].split("=")
		Find=xlsheet.cells.find("["+vCurInfo[0]+"]")
		if (Find!=null)
		{
			xlsheet.cells.replace("["+vCurInfo[0]+"]",vCurInfo[1])
		}
	}
}
function ColFormat(val,format)
{
	//"1:YYYY-MM-DD"
	//"11:YYYY年MM月DD日"
	//"12:dd/mm/yyyy"
	//"2:0.00"
	//"3:短名称根据-截取
	//"4:文本格式?主要处理如设备编号等科学记数法显示的问题?
	if (format=="1")
	{
		return FormatDate(val,"","");
	}
	else if (format=="2")
	{
		val=val*100;
		val=Math.round(val,2);
		val=val/100;
		val=val.toFixed(2);
		return val;
	}
	else if (format=="3")
	{
		val=GetShortName(val,"-");
		return val;
	}
	else
	{
		return val
	}
}
//modified by ZY 20221115 3081237
function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#DHCEQEquipFacilityFind').datagrid('selectRecord', selectItems[i]); //根据id选中行 
        }
}

//判断选中记录的ID是否已存在checkedItems这个数组里
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
//将选中记录的ID是存储checkedItems这个数组里
function addselectItem(rowIndex, rowData) {
        //var row = jQuery('#tDHCEQEquipList').datagrid('getSelections');
        var rowid=rowData.TRowID;
        /// modefied by by zc 2017-06-25 ZC0031 begin
        var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowData.TRowID,'','','Y');
        var ret=res.split("^");
        if (ret[0]!="0")
        {
            $.messager.popover({msg:ret[1],type:'alert'});
            $('#DHCEQEquipFacilityFind').datagrid('unselectRow', rowIndex);
        }
        // modfied by ZY0306 20220711  台帐选择行存值到数组中
        else
        {
            var findindex=findSelectItem(rowid)
            if (findindex == -1) {
                    selectItems.push(rowid);
                }
            else
            {
                selectItems.splice(findindex, 1);
            }
        }
}
//清楚所有选中记录的ID
function removeAllItem(rows) {
        for (var i = 0; i < rows.length; i++) {
            var k = findSelectItem(rows[i].TRowID);
            if (k != -1) {
                selectItems.splice(i, 1);
            }
        }
}
//清楚单条选中记录的ID
function removeSingleItem(rowIndex, rowData) {
        var k = findSelectItem(rowData.TRowID);
        if (k != -1) {
            selectItems.splice(k, 1);
        }
}

// MZY0154	3259097		2023-03-03	修正方法名
function BImport_Click()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}
function BImport_IE()
{
	var FileName=GetFileName();
  	if (FileName=="") {return 0;}
  	var xlApp,xlsheet,xlBook
  	xlApp = new ActiveXObject("Excel.Application");
  	xlBook = xlApp.Workbooks.Add(FileName);
  	var xlsheet =xlBook.Worksheets(1);
  	var MaxRow=xlsheet.UsedRange.Cells.Rows.Count;
  	//alert(ExcelRows)
  	for (var Row=2;Row<=MaxRow;Row++)
	{
		var Col=1;
    	var EquipType=trim(xlsheet.cells(Row,Col++).text);
    	var EquipTypeDR="";
    	var Name=trim(xlsheet.cells(Row,Col++).text);
    	var No=trim(xlsheet.cells(Row,Col++).text);
    	var EquipDR="";
    	var Model=trim(xlsheet.cells(Row,Col++).text);
    	var ModelDR="";
    	var Quantity=trim(xlsheet.cells(Row,Col++).text);
    	var OriginalFee=trim(xlsheet.cells(Row,Col++).text);
    	var UseLoc=trim(xlsheet.cells(Row,Col++).text);
    	var UseLocDR="";
    	var Status=trim(xlsheet.cells(Row,Col++).text);
    	var StatusDR="";
    	var Provider=trim(xlsheet.cells(Row,Col++).text);
    	var ProviderDR="";
    	var ManuFactory=trim(xlsheet.cells(Row,Col++).text);
    	var ManuFactoryDR="";   
    	var LeaveFactoryNo=trim(xlsheet.cells(Row,Col++).text);
    	var Remark=trim(xlsheet.cells(Row,Col++).text);
		if (EquipType=="")
    	{
	    	alert("设备类组不能为空!");
	    	return 0;
    	}
    	if (EquipType!="")
		{
			EquipTypeDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipTypeID",EquipType);
			if (EquipTypeDR=="")
			{
				alert("第"+Row+"行 设备类组的信息不正确:"+EquipType);
				return 0;
			}
		}
    	if (Name=="")
    	{
	    	alert("设备名称为空!");
	    	return 0;
    	}
    	if (Status=="")
    	{
	    	alert("状态不能为空!");
	    	return 0;
    	}
		var ItemInfo=tkMakeServerCall("web.DHCEQCMasterItem","GetMasterInfoByDesc",Name,EquipTypeDR);
		if (ItemInfo=="")
		{
			alert("第"+Row+"行 "+Name+":尚未定义设备项,请先定义设备项!");
	   	 	return 0;
		}
		if (No!="")
		{
			EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
			if (EquipDR!="")
			{
				alert("第"+Row+"行 编号的信息已存在:"+No);
				return 0;
			}
		}
		if (Model!="")
		{
			ModelDR=tkMakeServerCall("web.DHCEQImportDataTool","GetModelID",Model,Name,EquipType);
			if (ModelDR=="")
			{
				alert("第"+Row+"行 "+Model+":尚未定义机型,请先定义机型!");
				return 0;
			}
		}
		if (parseInt(Quantity)<=0)
  		{
	  		alert("第"+Row+"行 设备数量错误,请您正确输入数量!")
	  		return 0;
 		}
 		if (parseInt(Quantity)!=Quantity)
		{
			alert("第"+Row+"行 设备数量错误,不允许输入小数位数量,请检查修正!");
			return 0;
		}
		if (Status=="新增")
		{
			StatusDR=0
		}
		else if (Status=="启用")
		{
			StatusDR=1
		}
		else
		{
			StatusDR=""
		}
		if (StatusDR=="")
		{
			alert("第"+Row+"行 状态的信息不正确:"+Status);
			return 0;
		}
    	if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc) 
			if (UseLocDR=="")
			{
				alert("第"+Row+"行 使用部门的信息不正确:"+UseLoc);
				return 0;
			}
		}
		if (Provider!="")
		{
			ProviderDR=tkMakeServerCall("web.DHCEQImportDataTool","GetProviderID",Provider,'1') 
			if (ProviderDR=="")
			{
				alert("第"+Row+"行 "+Provider+":尚未定义供应商,请先定义供应商!");
				return 0;
			}
		}
  		if (ManuFactory!="")
		{
			ManuFactoryDR=tkMakeServerCall("web.DHCEQImportDataTool","GetManuFactoryID",ManuFactory) 
			if (ManuFactoryDR=="")
			{
				alert("第"+Row+"行 "+ManuFactory+":尚未定义生产厂商,请先定义生产厂商!");
				return 0;
			}
		}
		
  		//alert("Saving...")
		//自动调用保存验收单
		var list=ItemInfo.split("^");
		var sort=26;	// MZY0154	3259138		2023-03-03
		if (Quantity=="1")
		{
			var combindata="";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+ModelDR; 
  			combindata=combindata+"^"+list[3]; 
  			combindata=combindata+"^"+list[6];
  			combindata=combindata+"^"+list[1];
  			combindata=combindata+"^"+list[sort+8];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+LeaveFactoryNo;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
	  		combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
    		combindata=combindata+"^"+ProviderDR;
  			combindata=combindata+"^"+ManuFactoryDR;
  			combindata=combindata+"^"+OriginalFee;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Remark;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+StatusDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";  //add by zx 2017-11-10 日期格式转换去掉 Bug ZX0048 需求号:479138
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[2];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+No;
  			combindata=combindata+"^";;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[4];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
			if (result<0) alert("第"+i+"行 <"+xlsheet.cells(i,4).text+"> 信息导入失败!!!请载剪该行信息重新整理后再次导入该行信息.");
		}
		else
		{
			for (var j=0;j<Quantity;j++)
			{
				var combindata="";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+ModelDR; 
  				combindata=combindata+"^"+list[3]; 
  				combindata=combindata+"^"+list[6];
  				combindata=combindata+"^"+list[1];
  				combindata=combindata+"^"+list[sort+8];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+LeaveFactoryNo;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
	  			combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
    			combindata=combindata+"^"+ProviderDR;
  				combindata=combindata+"^"+ManuFactoryDR;
  				combindata=combindata+"^"+OriginalFee;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Remark;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+StatusDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";  //add by zx 2017-11-10 日期格式转换去掉 Bug ZX0048 需求号:479138
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[2];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+No;
  				combindata=combindata+"^";;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[4];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
				if (result<0) alert("第"+i+"行 <"+xlsheet.cells(i,4).text+"> 信息导入失败!!!请载剪该行信息重新整理后再次导入该行信息.");
			}	
		}
	}
	
  	xlsheet.Quit;
  	xlsheet=null;
  	xlBook.Close (savechanges=false);
  	xlApp=null;
  	alert("导入简易设备信息操作完成!请核对相关信息.");
	window.location.reload();
}
function BImport_Chrome()
{
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))		//add by czf 20200611 1342552 begin		//czf 20200811 1456821
	{
		alertShow("没有数据导入！")
		return 0;
	}		//add by czf 20200611 1342552 end
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
    	var EquipType=trim(RowInfo[Row-1][Col++]);
    	var EquipTypeDR="";
    	var Name=trim(RowInfo[Row-1][Col++]);
    	var No=trim(RowInfo[Row-1][Col++]);
    	var EquipDR="";
    	var Model=trim(RowInfo[Row-1][Col++]);
    	var ModelDR="";
    	var Quantity=trim(RowInfo[Row-1][Col++]);
    	var OriginalFee=trim(RowInfo[Row-1][Col++]);
    	var UseLoc=trim(RowInfo[Row-1][Col++]);
    	var UseLocDR="";
    	var Status=trim(RowInfo[Row-1][Col++]);
    	var StatusDR="";
    	var Provider=trim(RowInfo[Row-1][Col++]);
    	var ProviderDR="";
    	var ManuFactory=trim(RowInfo[Row-1][Col++]);
    	var ManuFactoryDR="";   
    	var LeaveFactoryNo=trim(RowInfo[Row-1][Col++]);
    	var Remark=trim(RowInfo[Row-1][Col++]);
		if (EquipType=="")
    	{
	    	alert("设备类组不能为空!");
	    	return 0;
    	}
    	if (EquipType!="")
		{
			EquipTypeDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipTypeID",EquipType);
			if (EquipTypeDR=="")
			{
				alert("第"+Row+"行 设备类组的信息不正确:"+EquipType);
				return 0;
			}
		}
    	if (Name=="")
    	{
	    	alert("设备名称为空!");
	    	return 0;
    	}
    	if (Status=="")
    	{
	    	alert("状态不能为空!");
	    	return 0;
    	}
		var ItemInfo=tkMakeServerCall("web.DHCEQCMasterItem","GetMasterInfoByDesc",Name,EquipTypeDR);
		if (ItemInfo=="")
		{
			alert("第"+Row+"行 "+Name+":尚未定义设备项,请先定义设备项!");
	   	 	return 0;
		}
		if (No!="")
		{
			EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
			if (EquipDR!="")
			{
				alert("第"+Row+"行 编号的信息已存在:"+No);
				return 0;
			}
		}
		if (Model!="")
		{
			ModelDR=tkMakeServerCall("web.DHCEQImportDataTool","GetModelID",Model,Name,EquipType);
			if (ModelDR=="")
			{
				alert("第"+Row+"行 "+Model+":尚未定义机型,请先定义机型!");
				return 0;
			}
		}
		if (parseInt(Quantity)<=0)
  		{
	  		alert("第"+Row+"行 设备数量错误,请您正确输入数量!")
	  		return 0;
 		}
 		if (parseInt(Quantity)!=Quantity)
		{
			alert("第"+Row+"行 设备数量错误,不允许输入小数位数量,请检查修正!");
			return 0;
		}
		if (Status=="新增")
		{
			StatusDR=0
		}
		else if (Status=="启用")
		{
			StatusDR=1
		}
		else
		{
			StatusDR=""
		}
		if (StatusDR=="")
		{
			alert("第"+Row+"行 状态的信息不正确:"+Status);
			return 0;
		}
    	if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc) 
			if (UseLocDR=="")
			{
				alert("第"+Row+"行 使用部门的信息不正确:"+UseLoc);
				return 0;
			}
		}
		if (Provider!="")
		{
			ProviderDR=tkMakeServerCall("web.DHCEQImportDataTool","GetProviderID",Provider,'1') 
			if (ProviderDR=="")
			{
				alert("第"+Row+"行 "+Provider+":尚未定义供应商,请先定义供应商!");
				return 0;
			}
		}
  		if (ManuFactory!="")
		{
			ManuFactoryDR=tkMakeServerCall("web.DHCEQImportDataTool","GetManuFactoryID",ManuFactory) 
			if (ManuFactoryDR=="")
			{
				alert("第"+Row+"行 "+ManuFactory+":尚未定义生产厂商,请先定义生产厂商!");
				return 0;
			}
		}
		
  		//alert("Saving...")
		//自动调用保存验收单
		var list=ItemInfo.split("^");
		var sort=26;	// MZY0154	3259138		2023-03-03
		if (Quantity=="1")
		{
			var combindata="";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+ModelDR; 
  			combindata=combindata+"^"+list[3]; 
  			combindata=combindata+"^"+list[6];
  			combindata=combindata+"^"+list[1];
  			combindata=combindata+"^"+list[sort+8];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+LeaveFactoryNo;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
	  		combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
    		combindata=combindata+"^"+ProviderDR;
  			combindata=combindata+"^"+ManuFactoryDR;
  			combindata=combindata+"^"+OriginalFee;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Remark;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+StatusDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";  //add by zx 2017-11-10 日期格式转换去掉 Bug ZX0048 需求号:479138
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[2];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+UseLocDR;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+No;
  			combindata=combindata+"^";;
  			combindata=combindata+"^";
  			combindata=combindata+"^"+list[4];
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^"+Name;
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^false";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
  			combindata=combindata+"^";
			var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
			if (result<0) 
			{
				Error="第"+Row+"行信息导入失败!!!"
				alertShow(Error);
				Row=RowInfo.length+1
			}
		}
		else
		{
			for (var j=0;j<Quantity;j++)
			{
				var combindata="";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+ModelDR; 
  				combindata=combindata+"^"+list[3]; 
  				combindata=combindata+"^"+list[6];
  				combindata=combindata+"^"+list[1];
  				combindata=combindata+"^"+list[sort+8];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+LeaveFactoryNo;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
	  			combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
    			combindata=combindata+"^"+ProviderDR;
  				combindata=combindata+"^"+ManuFactoryDR;
  				combindata=combindata+"^"+OriginalFee;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Remark;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+StatusDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";  //add by zx 2017-11-10 日期格式转换去掉 Bug ZX0048 需求号:479138
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[2];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+UseLocDR;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+No;
  				combindata=combindata+"^";;
  				combindata=combindata+"^";
  				combindata=combindata+"^"+list[4];
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^"+Name;
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^false";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
  				combindata=combindata+"^";
				var result=tkMakeServerCall("web.DHCEQEquip","SaveData",'','',combindata,curUserID,'','2') 
				if (result<0) 
				{
					Error="第"+Row+"行信息导入失败!!!"
					alertShow(Error);
					Row=RowInfo.length+1
				}
			}	
		}
	}
	
  	if (Error=="")
	{
		messageShow('alert','info','提示','导入简易设备信息操作完成!请核对相关信息.','',importreload,'');		
	}
}
function importreload()
{
	window.location.reload();
}
//modify by zc0125 2022-11-09 增加导入功能 end
