/*





*/

/****************************
	ҽ����鲡����ʿ��ѯ����
*****************************/

var TemplatePath="";



$(function(){
	
	initView();
	initEvent();
	
	// web.DHCRisCommFunction.GetPath
	//var GetPathFunction=document.getElementById("GetPath").value;
 	//TemplatePath=cspRunServerMethod(GetPathFunction);
 	
 	var data=$.m({
					ClassName:"web.DHCRisCommFunction",
					MethodName:"GetPath"
					//LocDr:session["LOGON.CTLOCID"]
					
				},false);
				
	if (data!="")
	{
		TemplatePath=data;
	}
	//alert(data);
});

function initView()
{
	
	$HUI.datagrid("#orderlist",{
		//title:'����',
		fit:true,
		//height:400,
		//url:LINK_CSP+'?ClassName=web.DHCRisSetTimePeriod&MethodName=getTimePeriod',    //getTimePeriod
		rownumbers:true,
		pagination:true,
		pageSize:20,
		pageList: [20],
		fitColumns:false,
		//striped:true,
		//columns:columns,	
		
		columns:[[
			//{field:'ck',checkbox:true},
			{field:'ck',checkbox:true},
			{field:'Tregno',title:'����ID'},
			{field:'Tname',title:'����'},
			{field:'Tsex',title:'�Ա�'},
			{field:'TAge',title:'����'},
			{field:'Tbedno',title:'����'},
			{field:'Titemname',title:'�����Ŀ'},
			{field:'TstrDate',title:'ҽ������'},
			{field:'TstrTime',title:'ҽ��ʱ��'},
			{field:'Tdepname',title:'ִ�п���'},   ///
			//{field:'TPatientStatus',title:'���״̬'},
			{field:'TAppointDate',title:'ԤԼ����'},
			{field:'TAppointstTime',title:'ԤԼʱ��'},
			{field:'TResDesc',title:'��Դ'},
			{field:'TstrRegDate',title:'�Ǽ�����'},
			{field:'TstrRegTime',title:'�Ǽ�ʱ��'},
			{field:'TStudyNo',title:'����'},
			{field:'TReportDoc',title:'����ҽ��'},
			{field:'TReportVerifyDoc',title:'���ҽ��'},
			{field:'TRisStatusDesc',title:'״̬'},
			{field:'Twarddesc',title:'����'},

			{field:'PrintFalg',title:'�Ƿ��ӡ'},
			{field:'OEOrdItemID',title:'ҽ��Rowid'},
			{field:'MeothodDesc',title:'ԤԼ��ʽ'},
			{field:'RecLocDR',title:'����id'},
			//{field:'IsSend',title:'����'},
			//{field:'Memo',title:'��ע'},
			{field:'bodyRowid',title:'��λID'}


			]
		]

	});
	
	
	
	//recLocCmb
	$HUI.combobox("#recLocCmb",{
		valueField:'rw',  //RowId^Description
		textField:'desc',
		//data:info
		mode:'remote',
		url:$URL+"?ClassName=web.DHCRisWardQuery&QueryName=QueryExeLoc&ResultSetType=array",
		onShowPanel: function () { 
			
			var url = $(this).combobox('options').url;
			if (!url){
				//$(this).combobox('options').mode = 'remote';
				var url = $URL+"?ClassName=web.DHCRisWardQuery&QueryName=QueryExeLoc&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad:function(params){
			//params.USERDR=session['LOGON.USERID']
			//alert(params.q);
			params.Desc=params.q
		}
	});
	
	$HUI.combobox("#wardCmb",{
		valueField:'TRowid',  //RowId^Description
		textField:'Desc',
		defaultFilter:4,
		//data:info
		url:$URL+"?ClassName=web.DHCRisWardQuery&QueryName=QueryWard&ResultSetType=array",
		onBeforeLoad:function(params){
			params.InDesc=""
		}
	});
	
	
	var data=$.m({
					ClassName:"web.DHCRisWardQuery",
					MethodName:"GetWardByLoc",
					LocDr:session["LOGON.CTLOCID"]
					
				},false);
				
	if (data!="")
	{
		$('#wardCmb').combobox('setValue',data.split("^")[1]);
	}
	
	
	$HUI.combobox("#examItemCmb",{
		valueField:'ItemRowID',  //RowId^Description
		textField:'ARCIMDesc',
		mode:'remote',
		//data:info
		url:$URL+"?ClassName=web.DHCRisWardQuery&QueryName=QueryOrdItemCS&ResultSetType=array",
		onBeforeLoad:function(params){
			params.ItemDesc=$('#examItemCmb').combobox('getText')
		}
	});
	
	
	
	$HUI.combobox("#statusCmb",{
		valueField:'code',
		textField:'desc',
		url:$URL+"?ClassName=web.DHCRisCommFunction&QueryName=QuerySystemPatientStatus&ResultSetType=array"
	});
	
	//$('#recLocCmb').combobox('setValue',session['LOGON.CTLOCID']);
	
	$('#stdate').datebox('setValue',getDateStr(0));
	$('#enddate').datebox('setValue',getDateStr(0));
	
	
	

}

function initEvent()
{
	$('#queryBtn').bind('click',RunQuery);
	$('#clearBtn').bind('click',clear_click);
	//onClickRow:clickOrderList
	$('#orderlist').datagrid({
		onClickRow:clickOrderList
	});
	
	$('#regNo').bind('keydown',function (e) {
		if (e.keyCode == 13 && this.value.length > 0) {
			//alert("start");
			RunQuery();
		}
	});
	
	$('#printSelectBtn').bind('click',print_click);
	
	
}

function getDateStr(days)
{ 
	var date = new Date();
	date.setDate(date.getDate()+days);
    var year = date.getFullYear();       //��
    var month = date.getMonth() + 1;     //��
    var day = date.getDate();            //��
    var clock = year + "-";
    if(month < 10) clock += "0";       
    clock += month + "-";
    if(day < 10) clock += "0"; 
    clock += day;
    return clock; 
}

function clickOrderList(rowIndex, rowData)
{
	/*
	//alert(rowData.TOeorditemdr);
	var rows=$('#orderlist').datagrid('getRows');
	//alert(rows.length);
	//alert(rowIndex);
	//alert($('#orderlist').datagrid('getSelected'));
	
	for (var index=0;index<=rows.length-1;index++)
	{
		//alert(rows[index]['TOeorditemdr']);
		if (rows[index].Tregno!=rowData.Tregno)
		{
			$('#orderlist').datagrid('unselectRow',index);
			//$('#orderlist').datagrid('selectRow',index);
			//$('#orderlist').datagrid('selectRecord',index)
		}
	}
	*/
}
	

function RunQuery()
{
	
	var InRegNo=$('#regNo').val();
	if(InRegNo!="")
	{
		var zero="";
		for (var i=0;i<10-InRegNo.length;i++)
		{
		   zero=zero+"0";
		}
		InRegNo=zero+InRegNo;
		//document.getElementById("InRegNo").value=InRegNo;
		$('#regNo').val(InRegNo);
	}
	
	
	
	var ward=$('#wardCmb').combobox('getValue');
	if (ward==undefined)
	{
		ward="";
	}
	var arcItemRowid=$('#examItemCmb').combobox('getValue');
	if (arcItemRowid==undefined)
	{
		arcItemRowid="";
	}
	
	var InStudyNo=$('#accessionNo').val();
	var RisStatusCode=$('#statusCmb').combobox('getValue');
	if (RisStatusCode==undefined)
	{
		RisStatusCode="";
	}
	var RecLocId=$('#recLocCmb').combobox('getValue');
	if (RecLocId==undefined)
	{
		RecLocId="";
	}

	var gUserID=session['LOGON.USERID'];
	
	var IsPrint="N";
	var IsBedOrd="N";
	if ($('#showPrintChkbox').checkbox('getValue'))
	{
		IsPrint="Y";
	}
	
	var selByBookDate="N";
	if ($('#bookDateChk').checkbox('getValue'))
	{
		selByBookDate="Y";
	}

	var strCondition=ward+"^"+arcItemRowid+"^"+InRegNo+"^"+InStudyNo+"^"+RisStatusCode+"^"+RecLocId+"^"+IsPrint+"^"+IsBedOrd+"^"+gUserID+"^^"+selByBookDate;
	
	//alert(strCondition);
	$HUI.datagrid('#orderlist',{
		//idField:'Ind', 
	 	url:$URL,  
	 	queryParams:{
			ClassName:"web.DHCRisWardQuery",
			QueryName:"QueryItemByWard",
			strCondition:strCondition,
			startdate:$('#stdate').datebox('getValue'),
			enddate:$('#enddate').datebox('getValue')
			
		}	

	},false);
	
	
}

function clear_click()
{
	//$("#orderlist").datagrid("loadData", { total: 0, rows: [] });
	$("#orderlist").datagrid("loadData", []);
	$('#regNo').val("");
	$('#accessionNo').val("");
	//$('#recLocCmb').combobox('setValue',session['LOGON.CTLOCID']);
	$('#stdate').datebox('setValue',getDateStr(0));
	$('#enddate').datebox('setValue',getDateStr(0));
	$('#cardTypeCmb').combobox('setValue',"");
	$('#statusCmb').combobox('setValue',"");
	$('#examItemCmb').combobox('setValue',"");
	$('#recLocCmb').combobox('setValue',"");
	//alert('info');
	
}




//��ӡѡ������
function print_click()
{
	var printDate = tkMakeServerCall("web.DHCRisWardQuery","GetCurrentDate");
	var printDoc = session['LOGON.USERNAME'];
	
	var printArr=new Array();
	var listTitle="����^�ǼǺ�^�Ա�^����^����^����^ҽ����Ŀ^ԤԼ����^ԤԼ��Դ^״̬^ִ�п���"
	printArr.push(listTitle);
	
	//var str=arr.join("");

	var selectRows=$('#orderlist').datagrid('getSelections');
	for ( var i=0;i<selectRows.length;i++)
	{
		
		var OeItemID=selectRows[i].OEOrdItemID;
		var depname=selectRows[i].Tdepname;
		var BedNo=selectRows[i].Tbedno;
		var RegNo=selectRows[i].Tregno;
		var Name=selectRows[i].Tname;
		var Sex=selectRows[i].Tsex;
		var Age=selectRows[i].TAge;
		var ItemName=selectRows[i].Titemname;
		var Date=selectRows[i].TstrDate;
		var Time=selectRows[i].TstrTime;
		var AppointDate=selectRows[i].TAppointDate;
		var AppointstTime=selectRows[i].TAppointstTime;
		var ResDesc=selectRows[i].TResDesc;
		var PrintFalg=selectRows[i].PrintFalg;
		var wardname=selectRows[i].Twarddesc;
		var RegDate=selectRows[i].TstrRegDate;
		var RegTime=selectRows[i].TstrRegTime;
		var StudyNo=selectRows[i].TStudyNo;
		var ReportDoc=selectRows[i].TReportDoc;
		var ReportVerifyDoc=selectRows[i].TReportVerifyDoc;
		var RisStatusDesc=selectRows[i].TRisStatusDesc;
		var BodyRowid=selectRows[i].bodyRowid;
		var MeothodDesc=selectRows[i].MeothodDesc;
		var PrintDate="";
		var PrintTime="";

		if(OeItemID!="" && PrintFalg!="Y")
		{
		  	//web.DHCRisWardQuery.SetPrintFlag
			
			var data=$.m({
				ClassName:"web.DHCRisWardQuery",
				MethodName:"SetPrintFlag",
				oeorditemdr:OeItemID,
				bodyRowid:BodyRowid
			
			},false);
			//web.DHCRisWardQuery.SetPrintDateTime
			var printInfo=$.m({
				ClassName:"web.DHCRisWardQuery",
				MethodName:"SetPrintDateTime",
				oeorditemdr:OeItemID,
				bodyRowid:BodyRowid
			},false);
			
			if (printInfo!="")
			{
				var Item=printInfo.split("^"); 
				PrintDate=Item[0];
				PrintTime=Item[1];
			}
		}
	
		var printInfo = Name+"^"+RegNo+"^"+Sex+"^"+Age+"^"+wardname+"^"+BedNo+"^"+ItemName+"^"+AppointDate+" "+AppointstTime+"^"+ResDesc+"^"+RisStatusDesc+"^"+depname;
		
		printArr.push(printInfo);
	
		

	}
	
	var printListStr=printArr.join(String.fromCharCode(2));
	
	DHCP_GetXMLConfig("InvPrintEncrypt","BookDataList");
	var myobj=document.getElementById("ClsBillPrint");
	
	var MyPara = "PrintDate"+String.fromCharCode(2)+printDate
					+"^PrintDoc"+String.fromCharCode(2)+printDoc; 
	//DHCP_PrintFunNew(myobj,MyPara,printListStr);
	//DHCP_PrintFun(myobj,MyPara,"");
	//DHCP_XMLPrint(myobj,MyPara,"");
	DHCP_PrintFunHDLP("",MyPara,printListStr);
	/*
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRisWaiqinPrintYD.xls";
	    //alert(Template);
	    var CellRows ; 
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		   
	  	var selectRows=$('#orderlist').datagrid('getSelections');
		
		xlsheet.cells(2,2)=tkMakeServerCall("web.DHCRisWardQuery","GetCurrentDate"); //GetCurrentDate();
	 	xlsheet.cells(2,8)=session['LOGON.USERNAME'];
		
		var j=0;
		
		//alert(selectRows.length);
		for ( var i=0;i<selectRows.length;i++)
		{

			  j=j+1;
			  var OeItemID=selectRows[i].OEOrdItemID;
			  var depname=selectRows[i].Tdepname;
			  var BedNo=selectRows[i].Tbedno;
			  var RegNo=selectRows[i].Tregno;
			  var Name=selectRows[i].Tname;
			  var Sex=selectRows[i].Tsex;
			  var Age=selectRows[i].TAge;
			  var ItemName=selectRows[i].Titemname;
			  var Date=selectRows[i].TstrDate;
			  var Time=selectRows[i].TstrTime;
			  var AppointDate=selectRows[i].TAppointDate;
			  var AppointstTime=selectRows[i].TAppointstTime;
			  var ResDesc=selectRows[i].TResDesc;
			  var PrintFalg=selectRows[i].PrintFalg;
			  var wardname=selectRows[i].Twarddesc;
			  var RegDate=selectRows[i].TstrRegDate;
			  var RegTime=selectRows[i].TstrRegTime;
			  var StudyNo=selectRows[i].TStudyNo;
			  var ReportDoc=selectRows[i].TReportDoc;
			  var ReportVerifyDoc=selectRows[i].TReportVerifyDoc;
			  var RisStatusDesc=selectRows[i].TRisStatusDesc;
			  var BodyRowid=selectRows[i].bodyRowid;
			  var MeothodDesc=selectRows[i].MeothodDesc;
			  var PrintDate="";
			  var PrintTime="";
			  
			  if(OeItemID!="" && PrintFalg!="Y")
			  {
				  	//web.DHCRisWardQuery.SetPrintFlag
					
					var data=$.m({
						ClassName:"web.DHCRisWardQuery",
						MethodName:"SetPrintFlag",
						oeorditemdr:OeItemID,
						bodyRowid:BodyRowid
					
					},false);
					//web.DHCRisWardQuery.SetPrintDateTime
					var printInfo=$.m({
						ClassName:"web.DHCRisWardQuery",
						MethodName:"SetPrintDateTime",
						oeorditemdr:OeItemID,
						bodyRowid:BodyRowid
					},false);
					
					if (printInfo!="")
					{
						var Item=printInfo.split("^"); 
						PrintDate=Item[0];
						PrintTime=Item[1];
			  		}
				}
		
			  
			 xlsheet.cells(j+3,1)=wardname;
			 xlsheet.cells(j+3,2)=RegNo;
			 xlsheet.cells(j+3,3)=StudyNo;
			 xlsheet.cells(j+3,4)=Name;
			 xlsheet.cells(j+3,5)=Sex;
			 xlsheet.cells(j+3,6)=Age;
			 xlsheet.cells(j+3,7)=BedNo;
			 xlsheet.cells(j+3,8)=ItemName; 
			 xlsheet.cells(j+3,9)=depname; 
			 xlsheet.cells(j+3,10)=AppointDate; //+"  "+AppointstTime;
			 
			 xlsheet.cells(j+3,11)=AppointstTime;
			 if ((MeothodDesc=="����ԤԼ")||(MeothodDesc=="����ԤԼ"))
			 {
				xlsheet.cells(j+3,10)=MeothodDesc;
			 	xlsheet.cells(j+3,11)="";
			 }
			 xlsheet.cells(j+3,12)=ResDesc;
			 xlsheet.cells(j+3,13)=RegDate;
			 xlsheet.cells(j+3,14)=RegTime;
			 xlsheet.cells(j+3,15)=ReportDoc;
			 xlsheet.cells(j+3,16)=ReportVerifyDoc;
			 xlsheet.cells(j+3,17)=RisStatusDesc;
			 xlsheet.cells(j+3,18)=Date;
			 xlsheet.cells(j+3,19)=Time;
			 
			//}

		} 

		xlsheet.printout;
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
        
	}
	catch(e) 
	{
		alert(e.message);
	};
	*/
}

function GetCurrentDate()
{
	var d, s="";         
    d = new Date(); 
    var sDay="",sMonth="",sYear="";
    sDay = d.getDate();		
    if(sDay < 10)
    sDay = "0"+sDay;
    
    sMonth = d.getMonth()+1;		
    if(sMonth < 10)
    sMonth = "0"+sMonth;
    
    sYear  = d.getFullYear();	
    
    var sHoure=d.getHours();
    var sMintues=d.getMinutes();
    	
    s=sYear +"-"+sMonth+"-"+sDay+"    "+sHoure+":"+sMintues ;
    
    return s;

}
