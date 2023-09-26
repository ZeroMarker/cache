//attributecat.js
var Columns=getCurColumnsInfo('EM.G.AttributeCatList','','','');
$(function(){
	initDocument();
});
//modify by wl 2020-03-18 ɾ����Чlinkbutton ����toolbar
//modify by wl 2020-06-22���Ӳ���CIHTTypeDesc\��ť
function initDocument()
{
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	jQuery("#BatchImport").on("click", BatchImport_Clicked);
	initLookUp(); //��ʼ���Ŵ�
	initButton(); //��ť��ʼ��
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
	            text:'�����豸',
	            id:'batchadd',       
	            handler: function(){
	                 DealEquip();
	            }
	        },
	        	{
				iconCls: 'icon-clock',
	            text:'�������豸',
	            id:'icon-clock',       
	            handler: function(){
	                 WaitDealEquip();
	            }
	        },
	         {
				iconCls: 'icon-save',
	            text:'����',
	            id:'save',       
	            handler: function(){
	                 BSave_Clicked();
	            }
	        },
	         {
				iconCls: 'icon-remove',
	            text:'ɾ��',
	            id:'remove',       
	            handler: function(){
	                 BDelete_Clicked();
	            }
	        },
	     
	        ],
		rownumbers: false,  //���Ϊtrue������ʾһ���к��С�
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
	{ messageShow("","","","��ѡ���豸����")
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
	{messageShow("alert","error","������ʾ",jsonData.Data);return;}
	
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
	 messageShow("","","","��ѡ���豸����")
	 return;
	 }
	var url="dhceq.em.attributechoose.csp?&EACode="+getElementValue("EACode");
	showWindow(url,"�ɹ�ѡ����豸","","","icon-w-paper","","","","middle"); //modify by lmm 2020-06-05 UI
}
//add by wl 2020-03-18
function BAdd_Clicked()
{ 
	if(getElementValue("EACode")=="")
	 {	 
	 messageShow("","","","��ѡ���豸����")
	 return;
	 }
	var url="dhceq.em.addattributecat.csp?&EACode="+getElementValue("EACode");
	showWindow(url,"��������","","","icon-w-paper","","","","middle"); //modify by lmm 2020-06-05 UI
}
function BDelete_Clicked()
{ 
	var EACode=getElementValue("EACode")
	if(EACode=="")
	{ messageShow("","","","��ѡ���豸����")
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
		messageShow("alert","error","������ʾ","ɾ��ʧ��,������Ϣ:"+jsonData.Data);
		return
    }
}
//modify by wl 2020-06-22 ���Ӳ���
function BFind_Clicked()
{
	if(getElementValue("EACode")=="")
	{ messageShow("","","","��ѡ���豸����")
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
  xlsheet =xlBook.Worksheets("�豸���Է���ģ��");
  xlsheet = xlBook.ActiveSheet;
  var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
  if (ExcelRows<=1){ alertShow("����ģ��������")}
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
	  alertShow("�������");
	}	
	else
    {
		messageShow("alert","error","������ʾ","����ʧ��:"+jsonData.Data);
		return
    }
  xlsheet.Quit;
  xlsheet=null;
  xlBook.Close (savechanges=false);
  xlApp=null;

}
//add by wl 2020-06-22 ���Ӳ���
function WaitDealEquip()
 { 
 if(getElementValue("EACode")=="")
	{ messageShow("","","","��ѡ���豸����")
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
//add by wl 2020-06-22 enter��ѯ
 document.onkeydown=function(event){
            var e = event || window.event || arguments.callee.caller.arguments[0];          
             if(e && e.keyCode==13){ // enter ��
                 BFind_Clicked()
            }
        }; 