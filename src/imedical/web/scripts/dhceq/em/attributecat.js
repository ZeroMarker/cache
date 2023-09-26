//attributecat.js
var Columns=getCurColumnsInfo('EM.G.AttributeCatList','','','');
$(function(){
	initDocument();
});
//modify by wl 2020-03-18 删除无效linkbutton 增加toolbar
//modify by wl 2020-06-22增加参数CIHTTypeDesc\按钮
function initDocument()
{
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	jQuery("#BatchImport").on("click", BatchImport_Clicked);
	initLookUp(); //初始化放大镜
	initButton(); //按钮初始化
	initMessage("");
	initButtonWidth();
	defindTitleStyle(); 
	fillData();
	setRequiredElements("EAName") ;
	$HUI.datagrid("#tAttibuteCat",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCatList",
	        	Name:getElementValue("EquipName"),
	        	TypeDR:getElementValue("EALSubInfo"),
	        	Code:getElementValue("EACode"),
	        	CIHTTypeDesc:getElementValue("IHTTypeDesc")
		},
		toolbar:[
	        	{
				iconCls: 'icon-batch-add',
	            text:'增加设备',
	            id:'batchadd',       
	            handler: function(){
	                 DealEquip();
	            }
	        },
	        	{
				iconCls: 'icon-clock',
	            text:'待操作设备',
	            id:'icon-clock',       
	            handler: function(){
	                 WaitDealEquip();
	            }
	        },
	         {
				iconCls: 'icon-save',
	            text:'保存',
	            id:'save',       
	            handler: function(){
	                 BSave_Clicked();
	            }
	        },
	         {
				iconCls: 'icon-remove',
	            text:'删除',
	            id:'remove',       
	            handler: function(){
	                 BDelete_Clicked();
	            }
	        },
	     
	        ],
		rownumbers: false,  //如果为true，则显示一个行号列。
		singleSelect:false,
		fit:true,
		border:false,
		columns:Columns,
		fitColumns:true,   //add by lmm 2020-06-05 UI
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
		});	
	if(getElementValue("EACode")=="")
	{ 
		$("#EALSubInfo_IHTDesc").lookup("disable");
	}		
}

function BSave_Clicked()
{	
	var EACode=getElementValue("EACode")
	if(EACode=="")
	{ messageShow("","","","请选择设备属性")
		return;
	}
	var dataList="";
	var rows = $('#tAttibuteCat').datagrid('getSelections');
	if(rows.length==0)
	{ 
		messageShow("alert","error","",t[-9243]);
		return;
	}
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		oneRow.EALSubInfo=getElementValue("EALSubInfo");
		var RowData=JSON.stringify(rows[i]);
		if (dataList=="")
		{
			dataList=RowData;
		}
		else
		{
			dataList=dataList+"&"+RowData;
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","SaveData",dataList,EACode,"1","3");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0) 
	{
	url="dhceq.em.attributecat.csp?"+"&EACode="+getElementValue("EACode"); 
	window.location.href=url;

	}
	
	else
	{messageShow("alert","error","错误提示",jsonData.Data);return;}
	
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="EAName")
	{ 
		if(getElementValue("EAName")=="")
		{
			$("#EALSubInfo_IHTDesc").lookup("disable")
		}
		else
		{ 
			$("#EALSubInfo_IHTDesc").lookup("enable")
			setElement("EACode",rowData.TCode)
		}
	}
	
	if(elementID=="EALSubInfo_IHTDesc") 
	{	
			setElement("EALSubInfo",rowData.TRowID);
	}

}

function clearData(vElementID)
{ 	
	if(vElementID=="EALSubInfo_IHTDesc") 
	{
		setElement("EALSubInfo","");	
	}
	if(vElementID=="EAName")
	{ 
		setElement("EACode","");
	}
}
//add by wl 2020-03-18
function DealEquip()
{ 
	if(getElementValue("EACode")=="")
	 {	 
	 messageShow("","","","请选择设备属性")
	 return;
	 }
	var url="dhceq.em.attributechoose.csp?&EACode="+getElementValue("EACode");
	showWindow(url,"可供选择的设备","","","icon-w-paper","","","","middle"); //modify by lmm 2020-06-05 UI
}
//add by wl 2020-03-18
function BAdd_Clicked()
{ 
	if(getElementValue("EACode")=="")
	 {	 
	 messageShow("","","","请选择设备属性")
	 return;
	 }
	var url="dhceq.em.addattributecat.csp?&EACode="+getElementValue("EACode");
	showWindow(url,"新增分类","","","icon-w-paper","","","","middle"); //modify by lmm 2020-06-05 UI
}
function BDelete_Clicked()
{ 
	var EACode=getElementValue("EACode")
	if(EACode=="")
	{ messageShow("","","","请选择设备属性")
		return;
	}
	var dataList=""
	var rows = $('#tAttibuteCat').datagrid('getSelections');
	if(rows.length==0)
	{ 
		messageShow("alert","error","",t[-9243]);
		return;
	}
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData;
		}
		else
		{
			dataList=dataList+"&"+RowData;
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","SaveData",dataList,EACode,"2","3");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    window.location.reload();
	}	
	else
    {
		messageShow("alert","error","错误提示","删除失败,错误信息:"+jsonData.Data);
		return
    }
}
//modify by wl 2020-06-22 增加参数
function BFind_Clicked()
{
	if(getElementValue("EACode")=="")
	{ messageShow("","","","请选择设备属性")
		return;
	}
	var EACode= getElementValue("EACode")
	$HUI.datagrid("#tAttibuteCat",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCatList",
	        	Name:getElementValue("EquipName"),
	        	TypeDR:getElementValue("EALSubInfo"),
	        	Code:EACode,
	        	CIHTTypeDesc:getElementValue("IHTTypeDesc")
		}
		});		
}
//modify by wl 2020-03-18 
//modify by wl 2020-06-12 WL0067
function getParam(ID)
{ 

		if(ID=="TypeStr") return getElementValue("EACode")

	
}
function fillData()
{ 
	var EAName=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","GetEAName",getElementValue("EACode"));
	if (EAName!="")
	{ 
		setElement("EAName",EAName)
	}
}
//add by wl 2020-03-18
function BatchImport_Clicked()
{ 
  var FileName=GetFileName();
  if (FileName=="") {return 0;}
  var xlApp,xlsheet,xlBook
  xlApp = new ActiveXObject("Excel.Application");
  xlBook = xlApp.Workbooks.Add(FileName);
  xlsheet =xlBook.Worksheets("设备属性分类模板");
  xlsheet = xlBook.ActiveSheet;
  var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
  if (ExcelRows<=1){ alertShow("导入模板无数据")}
  var DataList="";
  for (var Row=2;Row<=ExcelRows;Row++)
  {
  	var Col=1;
    var IHTCode=trim(xlsheet.cells(Row,Col++).text);
    var IHTDesc=trim(xlsheet.cells(Row,Col++).text);
    var IHTType=trim(xlsheet.cells(Row,Col++).text);
    var RowData={"IHTCode":IHTCode,IHTDesc:IHTDesc,"IHTType":IHTType,"IHTInvalidFlag":"N"};
    if (DataList=="")
		{
			DataList=JSON.stringify(RowData);
		}
		else
		{
			DataList=DataList+"&"+JSON.stringify(RowData);
		}
  }
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","ImportAttributeCat",DataList);
 	jsonData=JSON.parse(jsonData);
  	if (jsonData.SQLCODE=="0")
	{
	  alertShow("导入完毕");
	}	
	else
    {
		messageShow("alert","error","错误提示","操作失败:"+jsonData.Data);
		return
    }
  xlsheet.Quit;
  xlsheet=null;
  xlBook.Close (savechanges=false);
  xlApp=null;

}
//add by wl 2020-06-22 增加参数
function WaitDealEquip()
 { 
 if(getElementValue("EACode")=="")
	{ messageShow("","","","请选择设备属性")
		return;
	}
	var EACode= getElementValue("EACode")
	$HUI.datagrid("#tAttibuteCat",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCatList",
	        	Name:getElementValue("EquipName"),
	        	TypeDR:getElementValue("EALSubInfo"),
	        	Code:EACode,
	        	CIHTTypeDesc:getElementValue("IHTTypeDesc"),
	        	CEALSubFlag:"Y"
		}
		});		
 	
 }
//add by wl 2020-06-22 enter查询
 document.onkeydown=function(event){
            var e = event || window.event || arguments.callee.caller.arguments[0];          
             if(e && e.keyCode==13){ // enter 键
                 BFind_Clicked()
            }
        }; 