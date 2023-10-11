//����	DHCPEHadCheckedList.hisui.js
//����	�Ѽ�/δ����Ա��Ϣ
//����	2020.11.23
//������  xy

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
			
	InitCombobox();
	
	InitHadCheckedListGrid();  
   
    //��ӡ����
	$("#BPrint").click(function() {	
		BPrint_Click();		
        });
	
	
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
	  
     $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

   $("#Name").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });    
     
  	//inti();
})


function inti()
{
	if(HadCheckedFlag!="Y"){
			$("#cCheckItemStatus").css('display','none');//����
			$("#CheckItemStatus").next(".combo").hide();//combobox����

	}
	if(HadCheckedFlag=="C"){
			$("#cCheckItemStatus").css('display','none');//����
			$("#CheckItemStatus").next(".combo").hide();//combobox����
			$("#cChargeStatus").css('display','none');//����
			$("#ChargeStatus").next(".combo").hide();//combobox����
	}

}


function BFind_click()
{
	var CTLocID=session['LOGON.CTLOCID'];
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	
	 var iName=$("#Name").val();
	
	 
	 var iDateFrom=$("#DateFrom").datebox('getValue');
	 
	 var iDateTo=$("#DateTo").datebox('getValue');
	 
	 var iDepartName=$("#DepartName").combogrid('getValue');
	if (($("#DepartName").combogrid('getValue')==undefined)||($("#DepartName").combogrid('getValue')=="")){var iDepartName="";} 
	
	
	 var iChargeStatus=$("#ChargeStatus").combobox('getValue');

	var iCheckItemStatus=$("#CheckItemStatus").combobox('getValue');
	
	 $("#HadCheckedListGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"HadCheckedList",
			RegNo:iRegNo,
			Name:iName,
			GroupID:GroupID,
			TeamID:TeamID,
			HadCheckType:HadCheckedFlag,
			DateFrom:iDateFrom,
			DateTo:iDateTo,
			DepartName:iDepartName,
			ChargeStatus:iChargeStatus,
			CheckItemStatus:iCheckItemStatus,
			SessionStr:SessionStr
		})
 	
 	
	
}


function BPrintNew_Click()
{

	var HadCheckType="",DateFrom="",DateTo=""
	var ret="";
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	 var Templatefilepath=prnpath+'DHCPEHadCheckedList.xls';
	 
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"+
        "xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells(2,16)).mergecells=true;"+ 
        "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,16)).mergecells=true;"+ 
        "xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells(2,16)).Borders.LineStyle='1';"+ 
        "xlSheet.Range(xlSheet.Cells(3,1),xlSheet.Cells(3,16)).Borders.LineStyle='1';"
      
      
       Rows=tkMakeServerCall("web.DHCPE.PreGADM","GetPostionNum");
		for(i=0;i<Rows;i++)
		{
			 var OneInfo=tkMakeServerCall("web.DHCPE.PreGADM","GetHadCheckedList",i+1)
		      var Info=OneInfo.split("^");
		      var HadCheckType=Info[7];
         	  
			  if (HadCheckType=="Y"){ HadCheckType="�Ѽ���Ա����"}
			  else if (HadCheckType=="N"){ HadCheckType="δ����Ա����"}
			  else if (HadCheckType=="C"){ HadCheckType="ȡ�������Ա����"}
          
          if(ret==""){
	          var k=4+i;
	          var n=i+1;
	           ret="xlSheet.Cells("+k+",1).Value='"+n+"';"+
	           "xlSheet.Cells("+k+",2).Value='"+Info[2]+"';"+  		//�ǼǺ�
	           "xlSheet.Cells("+k+",3).Value='"+Info[3]+"';"+  		//����
	           "xlSheet.Cells("+k+",4).Value='"+Info[4]+"';"+  		//�Ա�
	           "xlSheet.Cells("+k+",5).Value='"+Info[5]+"';"+   	//����6
	           "xlSheet.Cells("+k+",6).Value='"+Info[10]+"';"+   	//����5
	           "xlSheet.Cells("+k+",7).Value='"+Info[1]+"';"+    	//����6
	           "xlSheet.Cells("+k+",8).Value='"+Info[6]+"';"+  		//���7
	           "xlSheet.Cells("+k+",9).Value='"+Info[11]+"';"+  	//�Էѽ��7
	           "xlSheet.Cells("+k+",10).Value='"+Info[12]+"';"+   	//������Ŀ���7
	           "xlSheet.Cells("+k+",11).Value='"+Info[13]+"';"+  	//�ײͽ��7
		     	"xlSheet.Cells("+k+",12).Value='"+Info[14]+"';"+    	//�ƶ��绰
	           "xlSheet.Cells("+k+",13).Value='"+Info[15]+"';"+  		//����ʱ��
	           "xlSheet.Cells("+k+",14).Value='"+Info[16]+"';"+  	//֤������
	           "xlSheet.Cells("+k+",15).Value='"+Info[17]+"';"+   	//֤����
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//����״̬
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//����״̬
	           "xlSheet.Cells(1,1).Value='"+Info[0]+HadCheckType+"';"+
	           "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,16)).HorizontalAlignment= -4108;"+  //����
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",6)).HorizontalAlignment= -4108;"+
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",16)).Borders.LineStyle='1';"
		       
          }else{
	          var k=4+i;
	          var n=i+1;
	           ret=ret+"xlSheet.Cells("+k+",1).Value='"+n+"';"+
	           "xlSheet.Cells("+k+",2).Value='"+Info[2]+"';"+  		//�ǼǺ�
	           "xlSheet.Cells("+k+",3).Value='"+Info[3]+"';"+  		//����
	           "xlSheet.Cells("+k+",4).Value='"+Info[4]+"';"+  		//�Ա�
	           "xlSheet.Cells("+k+",5).Value='"+Info[5]+"';"+   	//����6
	           "xlSheet.Cells("+k+",6).Value='"+Info[10]+"';"+   	//����5
	           "xlSheet.Cells("+k+",7).Value='"+Info[1]+"';"+    	//����6
	           "xlSheet.Cells("+k+",8).Value='"+Info[6]+"';"+  		//���7
	           "xlSheet.Cells("+k+",9).Value='"+Info[11]+"';"+  	//�Էѽ��7
	           "xlSheet.Cells("+k+",10).Value='"+Info[12]+"';"+   	//������Ŀ���7
	           "xlSheet.Cells("+k+",11).Value='"+Info[13]+"';"+  	//�ײͽ��7
		     	"xlSheet.Cells("+k+",12).Value='"+Info[14]+"';"+    	//�ƶ��绰
	           "xlSheet.Cells("+k+",13).Value='"+Info[15]+"';"+  		//����ʱ��
	           "xlSheet.Cells("+k+",14).Value='"+Info[16]+"';"+  	//֤������
	           "xlSheet.Cells("+k+",15).Value='"+Info[17]+"';"+   	//֤����
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//����״̬
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//����״̬
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",6)).HorizontalAlignment= -4108;"+
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",16)).Borders.LineStyle='1';"
		       
         	  }
		}
		
         	  var Str=Str+ret+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
            "xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(Str)
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ;
  
 
	
}
function BPrint_Click()
{ 
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	
    var HadCheckType="",DateFrom="",DateTo=""
    
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	 var Templatefilepath=prnpath+'DHCPEHadCheckedList.xls';
	 
	//alert(Templatefilepath)
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	
	
	 xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,16)).Borders.LineStyle=1; 
     xlsheet.Range(xlsheet.Cells(3,1),xlsheet.Cells(3,16)).Borders.LineStyle=1;
     xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,16)).mergecells=true;
     xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,16)).mergecells=true;


    Rows=tkMakeServerCall("web.DHCPE.PreGADM","GetPostionNum");
    for(i=0;i<Rows;i++)
		{
			//Position_"^"_GroupDesc_"^"_TeamDesc_"^"_IRegNo_"^"_IName_"^"_ISexDRName_"^"_IAge_"^"_IDepName_"^"_HadCheckType_"^"_DateFrom_"^"_DateTo_"^"_OneAmount_"^"_IAmt_"^"_FItemAmt_"^"_FEntAmt
		      
		      var OneInfo=tkMakeServerCall("web.DHCPE.PreGADM","GetHadCheckedList",i+1)
		      var Info=OneInfo.split("^");
		      var HadCheckType=Info[7];
         	  
			  if (HadCheckType=="Y"){ HadCheckType="�Ѽ���Ա����"}
			  else if (HadCheckType=="N"){ HadCheckType="δ����Ա����"}
			  else if (HadCheckType=="C"){ HadCheckType="ȡ�������Ա����"}


		      
		      xlsheet.cells(4+i,1).Value=i+1;
		      xlsheet.cells(4+i,2).Value=Info[2];	//�ǼǺ�
		      xlsheet.cells(4+i,3).Value=Info[3]; 	//����
		      xlsheet.cells(4+i,4).Value=Info[4]; 	//�Ա�
		      xlsheet.cells(4+i,5).Value=Info[5]; 	//����6
		      xlsheet.cells(4+i,6).Value=Info[10];	//����5
		      xlsheet.cells(4+i,7).Value=Info[1];	//����6
		      xlsheet.cells(4+i,8).Value=Info[6]; 	//���7
		      xlsheet.cells(4+i,9).Value=Info[11]; 	//�Էѽ��7
		      xlsheet.cells(4+i,10).Value=Info[12]; 	//������Ŀ���7
		      xlsheet.cells(4+i,11).Value=Info[13]; 	//�ײͽ��7
			  xlsheet.cells(4+i,12).Value=Info[14]; //�ƶ��绰
			  xlsheet.cells(4+i,13).Value=Info[15]; //����ʱ��
			  xlsheet.cells(4+i,14).Value=Info[16]; //֤������
              xlsheet.cells(4+i,15).Value=Info[17]; //֤����
              xlsheet.cells(4+i,16).Value=Info[18]; //����״̬

		      //xlsheet.cells(3,7).Value="����"; 
              xlsheet.cells(1,1).Value=Info[0]+HadCheckType; 
             xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,6)).HorizontalAlignment =-4108;//����
             xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,16)).HorizontalAlignment =-4108;//����
         	// xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(9).LineStyle=1;//����
         	 // xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(3).LineStyle=1;
         	  xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,16)).Borders.LineStyle=1; }
   //xlsheet.SaveAs("d:\\������Ա����.xls")
   xlApp.Visible = true;
   xlApp.UserControl = true;
   }else{
	  BPrintNew_Click()
  } 

     

}

function InitHadCheckedListGrid()
{
	
	$HUI.datagrid("#HadCheckedListGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"HadCheckedList",
			HadCheckType:HadCheckedFlag,
			GroupID:GroupID,
			TeamID:TeamID,
			SessionStr:SessionStr
					
		},
		
		columns:[[
		    {field:'TPAADM',title:'TPAADM',hidden: true},	
			{field:'TGroupName',width:'100',title:'��������'},
			{field:'TTeamName',width:'100',title:'��������'},
			{field:'TRegNo',width:'120',title:'�ǼǺ�'},
			{field:'HPNo',width:'120',title:'����'},
			{field:'TName',width:'80',title:'����'},
			{field:'TApAmount',width:'100',title:'Ӧ�ս��',align:'right'},
			{field:'TIAmt',width:'100',title:'�Էѽ��',align:'right'},
			{field:'FItemAmt',width:'100',title:'������Ŀ���',align:'right'},
			{field:'FEntAmt',width:'100',title:'�ײͽ��',align:'right'},
			{field:'TTel',width:'120',title:'�ƶ��绰'},
			{field:'TArrivedDate',width:'120',title:'����ʱ��'},
			{field:'TCardDesc',width:'120',title:'֤������'},
			{field:'TIDCard',width:'170',title:'֤����'},
			{field:'TSex',width:'60',title:'�Ա�'},
			{field:'TAge',width:'80',title:'����'},
			{field:'TDepName',width:'100',title:'����'},
			{field:'TReportStatus',width:'80',title:'����״̬'},
			{field:'TItemlist',width:'80',title:'��Ŀ��ϸ',
			formatter:function(value,rowData,rowIndex){	
					
				if(rowData.TPAADM!=""){
					return "<span style='cursor:pointer;padding:0 10px 0px 20px' class='icon-paper' title='��Ŀ��ϸ' onclick='BItemList("+rowData.TPAADM+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
				}
				}}
					
		]],
		onSelect: function (rowIndex, rowData) {
			
			

		}
			
	})
}

function BItemList(PAADM){
	
	var lnk="dhcpeitemdetail.hisui.csp"+"?AdmId="+PAADM;
     //var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmItemStatusDetail"+"&AdmId="+PAADM;
	 websys_lu(lnk,false,'width=1300,height=600,hisui=true,title=��Ŀ��ϸ')
}
function InitCombobox()
{
	//�շ�״̬
	var ChargeStatusObj = $HUI.combobox("#ChargeStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		
		data:[
            {id:'0',text:'δ����'},
            {id:'2',text:'�Ѹ���'},
            {id:'1',text:'���ָ���'},
        ]

	});
	
	//����
	var DepartNameObj = $HUI.combogrid("#DepartName",{
       
        url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGDepart",
        mode:'remote',
        delay:200,
		idField:'DepartName',
        textField:'DepartName',
        onBeforeLoad:function(param){
			param.GID = GroupID;
            param.TeamID = TeamID;
            param.Type = "PGADM";
			param.Depart= param.q
			
        },
        onShowPanel:function()
        {
            $('#DepartName').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'DepartName',title:'����',width:130}
        ]]
        });

	

	//�Ѽ�״̬
	varCheckItemStatusObj = $HUI.combobox("#CheckItemStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'1',text:'�����Ѽ�'},
            {id:'2',text:'ȫ���Ѽ�'}
        ]

	});
}