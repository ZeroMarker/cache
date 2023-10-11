
//����	DHCPEItemDetail.hisui.js
//����	��Ŀ��ϸ
//����	2020-02-12
//������  sxt

var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
        $.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
          
               var objtbl = $(target).datagrid('getRows');
	           var rows=objtbl.length
	          
	         for (var j=0;j<rows;j++) {
		        var index=j;
		      	var Status=objtbl[j].StatDesc;
		      	var placerCode=objtbl[j].placerCode;

		        //alert(placerCode+"placerCode")
		        if(placerCode!="") { 
		      		 $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"ItemDesc"+"]").css({"background-color":objtbl[j].placerCode});
		     	 } 
		      
		 	   Status=Status.replace(" ","")
		 	   //alert(Status+"Status")
		 	   if(Status==$g("��ʵ")){
			 	   //alert(2)
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#F1C516"});
			 	  
		 	   }
		 	   if(Status==$g("ִ��")){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#4A991A"});
			 	  
		 	   }
		 	   if(Status==$g("л�����")){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#B5A99B"});
			 	  
		 	   }
		 	    if(Status==$g("ֹͣ")){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#EF4E38"});
			 	  
		 	   }
		 	  				
			}  
            }
});


$(function(){
		
	InitDataGrid();  
     
    // ���±걾��
	$("#BUpdateSpec").click(function() {	
		BUpdateSpec_click();		
        });
      
    //����ӡ
	$("#BSaveNoPrint").click(function() {	
		BSaveNoPrint_click();		
        });
             
    // л�����
    $('#Refuse').click(function(e){
    	Refuse_click();
    });
    
    // ȡ������
    $('#CancelDelayDate').click(function(e){
    	CancelDelayDate_click();
    });
    
    
   
   
})
function InitDataGrid()
{
	
	$HUI.datagrid("#ItemDetailGrid",{
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
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect:true,
		//selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.OEOrdItem",
			QueryName:"FindOItemStatusForAdm",
			AdmId:AdmId,
			CSPName:"dhcpeitemdetail.hisui.csp"   
		},
		
		columns:[[
			{
					title: 'ѡ��',
					field: 'Select',
					width: 70,
					checkbox:true,
					/*formatter:function(value,rowData,index){
						return "<input type='checkbox' onclick=\"GetSelectIds('" + value + "', '" + index + "')\"/>"; 
					}
					
                  */
				
				},
		
		    {field:'RowId',title:'TId',hidden: true},
			{field:'ARCICOrderType',title:'ARCICOrderType',hidden: true},
			{field:'StatDesc',width:80,title:'״̬',align:'center',
			 formatter:function(value,row,index){
				return  '<span style="color:#FBFDFA">'+value+'</span>';
 			}},
			{field:'ItemId',title:'TId',hidden: true},
			{field:'ItemDesc',width:200,title:'����'},
			{field:'Station',width:60,title:'վ��'},
			{field:'IsYQ',width:60,title:'�Ƿ�����'},
			{field:'YQDate',width:120,title:'��������'},
			{field:'ItemCode',width:100,title:'��Ŀ���'},
			{field:'LabNo',width:120,title:'�걾��'},
			{field:'BillStatus',width:80,title:'�շ�״̬'},
			{field:'Diet',width:80,title:'ע������'},
			{field:'TResultStatus',width:80,title:'����״̬'},
			{field:'AccountAmount',width:100,title:'Ӧ�ռ۸�',align:'right'},
			{field:'FactAmount',width:100,title:'�Żݼ۸�',align:'right'},
			{field:'TSpecName',width:100,title:'����'},
			{field:'TNotPrint',width:120,title:'�����ϲ���ӡ',formatter:function(value,row,index){
		
			if (value==0)
			{
				return "<input class='hisui-checkbox' type='checkbox' style='margin-left:40px;' "
				return "��ӡ"
			
				}
			else{
				return "<input class='hisui-checkbox' type='checkbox' checked='true' style='margin-left:40px;' "
				return "����ӡ"
				
				}
			
			}
			},
			{field:'TBloodDate',width:120,title:'��Ѫ����'},
			{field:'OEORIRowId',width:120,title:'ҽ��ID'},	
			{field:'TRefuseReason',width:180,title:'л��ԭ��'},
			{field:'TDrugStatus',width:100,title:'ҩƷ״̬'},
			{field:'TChecked',width:90,title:'��ҩ����',
			formatter:function(value,row,index){
				if(value==1){
				return "<input class='hisui-checkbox' type='checkbox' checked='true' style='margin-left:30px;' onclick='Chk_Click(\""+row.RowId+"\")'/>"
					}
				else{
				return "<input class='hisui-checkbox' type='checkbox' style='margin-left:30px;'  onclick='Chk_Click(\""+row.RowId+"\")'/>"
				}
			}
			},
			{field:'RecLocDesc',width:120,title:'���տ���'},
			{field:'Trans',title:'���Խ��',width:80,
			formatter:function(value,row,index){
					
					var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","IsLisRisStation",row.ItemId,session['LOGON.CTLOCID'])
					if(flag==1){

					return "<a href='#' onclick='TransTest(\""+index+"\")'>\
					<img style='padding-left:20px;' title='' src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
					</a>";
					}
					
			}},		
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			
				
				$("#Source").val(rowData.LabNo);	
				 var Status=rowData.StatDesc;
				if((Status==$g("ȡ�����"))||(Status==$g("л�����"))||(Status==$g("ִ��"))||(rowData.LabNo=="")){
						$("#BUpdateSpec").linkbutton('disable');
						$("#To").attr('disabled',true);
		
				}else{
					$("#BUpdateSpec").linkbutton("enable");
					$("#To").attr('disabled',false);
			             
				} 

		},
		onClickCell: function(rowIndex, field, value){
		if(field == 'TNotPrint'){
			// ���治��ӡ
			var eSrc = window.event.srcElement;
			if(eSrc.checked==true)
			{
				var ret=tkMakeServerCall("web.DHCPE.OEOrdItem","SaveOneNoPrint",$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId,"Y")
				$.messager.alert("��ʾ", "����ɹ�", 'success');
				$(this).datagrid('reload')
				}
			if(eSrc.checked==false)
			{
				var ret=tkMakeServerCall("web.DHCPE.OEOrdItem","SaveOneNoPrint",$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId,"")
				$.messager.alert("��ʾ", "����ɹ�", 'success');
				$(this).datagrid('reload')
				}
			
			
		}
		if(field == 'TChecked'){
			var FeeStatus=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].BillStatus;
			
			// ������ҩ����
			var DrugStatus=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TDrugStatus;
			if(DrugStatus!=$g("�ѷ�ҩ")) return false;
			if(FeeStatus.indexOf($g("����")) == -1 )
			{
			
			$.messager.alert("��ʾ", "����ҩƷ��ȥ�˷��������", 'success');
			
			return false;
			}
			
			var FeeStatus=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TDrugStatus;
			if(FeeStatus.indexOf($g("�ѷ�ҩ")) == -1 )
			{
			
			$.messager.alert("��ʾ", "�����ѷ�ҩҽ������������ҩ", 'success');
			
			return false;
			}
			
			var eSrc = window.event.srcElement;
			if(eSrc.checked==true)
			{
				var feeid="1"+"^"+$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TPreItemID 
				var drugperm=tkMakeServerCall("web.DHCPE.ItemFeeList","DrugPermControl",feeid,0,"",session['LOGON.CTLOCID'],session['LOGON.USERID'])
				//alert(drugperm+"drugperm")
				if(drugperm!=2)
				{
					//var ret=tkMakeServerCall("web.DHCPE.OEOrdItem","SaveOneNoPrint",$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId,"Y")
					$.messager.alert("��ʾ", "����ɹ�", 'success');
					$(this).datagrid('reload')
				}
				else{
					setColumnValue(rowIndex,"TChecked",0)
					$.messager.alert("��ʾ", "����ʧ��,ʧ�ܴ���"+drugperm, 'error');
				return false;	
				}
			}
			if(eSrc.checked==false)
			{
				//  ##class(PHA.FACE.OUT.Com).DelOutPhReq("1909||3^200270||2")
				var OEID=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId
				var ret=tkMakeServerCall("web.DHCPE.ItemFeeList","CancelDrugApply",OEID)
				if(ret==0){
					$.messager.alert("��ʾ", "ȡ������ɹ�", 'success');
					$(this).datagrid('reload')
				}
				else{
					setColumnValue(rowIndex,"TChecked",1)
					$.messager.alert("��ʾ", "ȡ������ʧ�ܣ�ʧ�ܴ���"+ret, 'error');
				
				return false;
				}
			}
			
			
		}
		
		},
		onLoadSuccess: function(rowData){
			
			
			for ( var i = 0; i < rowData.rows.length; i++) {
				//$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true;
			
		    if (rowData.rows[i].TDrugStatus!=$g("�ѷ�ҩ")) {
					$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true
						//$(this)[i].TChecked.disabled = true;

					}
			 if (rowData.rows[i].BillStatus.indexOf($g("����")) == -1 ) {
					$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true
						//$(this)[i].TChecked.disabled = true;

					}
					


	     }
			
			
		}	
			
	})

}

/*
function TransTest(OEORI)
{
	
	var lnk="dhcpetesttransresult.csp"+"?OEID="+OEORI
			;
	
	var wwidth=800;
	var wheight=600;
	
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	//var ret=window.showModalDialog(lnk, "", nwin); 
	//var cwin=window.open(lnk,"_blank",nwin)	
	websys_lu(lnk,false,'width=870,height=600,hisui=true,title=���Խ��')
	
	}
*/
function TransTest(index)
{
	
	var selectrow =$('#ItemDetailGrid').datagrid('getRows')[index];
	var OEORI=selectrow. OEORIRowId ;
	var Status=selectrow.StatDesc;
	var ItemDesc=selectrow.ItemDesc;
	var LabNo=selectrow.LabNo
	
	var lnk="dhcpetransresultdetail.csp"+"?OEID="+OEORI+"&Status="+Status+"&ItemDesc="+ItemDesc+"&LabNo="+LabNo
		;
	//alert(lnk)
	websys_lu(lnk,false,'width=1200,height=600,hisui=true,title='+ItemDesc+$g("--���Խ��"))
	
	
	}




// ��������
function CancelDelayDate_click()
{
	
	var UserID=session['LOGON.USERID'];
	var OEORIRowIdStr="";
	var SelectIds=""
	var selectrow = $("#ItemDetailGrid").datagrid("getChecked");//��ȡ�������飬��������
	//alert(selectrow.length+"selectrow.length")
  	if(selectrow.length=="0"){
	  	$.messager.alert("��ʾ","��ѡ����������ڵ�ҽ����","info");
		return false;
  	}
  	
	for(var i=0;i<selectrow.length;i++){	
	    if(selectrow[i].IsYQ==$g("��")) continue;
		if (OEORIRowIdStr==""){
				OEORIRowIdStr=selectrow[i].OEORIRowId;
			}else{
				OEORIRowIdStr=OEORIRowIdStr+"^"+selectrow[i].OEORIRowId;
			} 
	}

	if(OEORIRowIdStr==""){
		$.messager.alert("��ʾ","û�����㳷�����ڵ���Ŀ��","info");
		return false;
	}
	
	var DelayRet=tkMakeServerCall("web.DHCPE.OrderPostPoned","CancelDelay",OEORIRowIdStr,UserID);
	if(DelayRet<0){
		$.messager.alert("��ʾ","����������Ŀʧ�ܣ�","info");
		return false;
	}else{
		$.messager.alert("��ʾ","����������Ŀ�ɹ���","info");
		$("#ItemDetailGrid").datagrid('reload'); 
		return false;
		}
	
}


//����/л����� 
function Refuse_click(){
	
	var OEORIRowIdStr="";
	var SelectIds=""
	var selectrow = $("#ItemDetailGrid").datagrid("getChecked");//��ȡ�������飬��������
	//alert(selectrow.length+"selectrow.length")

	for(var i=0;i<selectrow.length;i++){

		if(selectrow[i].StatDesc==$g("ֹͣ")){
			$.messager.alert("��ʾ","ֹͣ��ҽ������л�����!","info");
			return false;
		}

       if(selectrow[i].TResultStatus==$g("�Ѳ�")){
			
			$.messager.alert("��ʾ","��ҽ���Ѳɼ�������л�����!","info");
			return false;
		
		}

		if(selectrow[i].ARCICOrderType=="R"){
			
			$.messager.alert("��ʾ","ҩƷ��ҽ������л�����!","info");
			return false;
		}
		
	   if(selectrow[i].ARCICOrderType=="M"){
			
			$.messager.alert("��ʾ","������ҽ������л�����!","info");
			return false;
		}

		if (OEORIRowIdStr==""){
				OEORIRowIdStr=selectrow[i].OEORIRowId;
			}else{
				OEORIRowIdStr=OEORIRowIdStr+"^"+selectrow[i].OEORIRowId;
			} 
	}



	if(OEORIRowIdStr==""){
		$.messager.alert("��ʾ","��ѡ��ҽ��!","info");
		return false;
	}
	
    var flag=""
	var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetReportStaus",OEORIRowIdStr);
	if((flag==$g("�Ѹ���"))||(flag==$g("�ѷ���"))||(flag==$g("�Ѵ�ӡ")))
	{
		
		$.messager.confirm('ȷ��', $g("����״̬�ǣ�")+flag+$g(", ȷ��Ҫ���иò�����?"), function(t) {
		if (t) {
				RefuseCommon(OEORIRowIdStr);

		}else{
			return false;
		}
		
	});
		
	}else{
		RefuseCommon(OEORIRowIdStr);
	}
	
}


function RefuseCommon(OEORIRowIdStr)
{
	   
    var UserID=session['LOGON.USERID'];
	var RefuseCodeStr="";
	var Arr=OEORIRowIdStr.split("^");
	var Length=Arr.length;
	for (var i=0;i<Length;i++)
	{ 
		var OEORIRowId=Arr[i];
		var RefuseReason=$("#RefuseReason").val();
    	var OEORIRowId=OEORIRowId+"^"+RefuseReason;
		//alert(OEORIRowId+"OEORIRowId")
		var RefuseCode=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEORIRowId,"",UserID);
	
	if(RefuseCodeStr==""){var RefuseCodeStr=RefuseCode;}
	else{var RefuseCodeStr=RefuseCodeStr+"^"+RefuseCode;}
	
	}
	
	var RefuseArr=RefuseCodeStr.split("^");
	var RefuseLength=RefuseArr.length;
	var j=0
	for (var ii=0;ii<RefuseLength;ii++)
	{ 
		if(RefuseArr[ii]=="0") {j++;} 
	
	}
	if(ii==j){var flag="0";}
	if(RefuseCodeStr.indexOf("-1")>=0){var flag="-1";}
	if (flag=='0') {
		
		$.messager.alert("��ʾ","�޸ĳɹ�!","success");
		
		}
	else if(flag=="-1")
	{
		
		$.messager.alert("��ʾ","��ִ����Ŀ�����ٽ��в���!","info");
		
	}else{
		
		$.messager.alert("��ʾ","�ܾ�ʧ��!","error");
   		
}
	$("#RefuseReason").val("");
	$("#ItemDetailGrid").datagrid('reload'); 
}


function BSaveNoPrint_click()
{
	var IDS=""
	var items = $("input[name='TNotPrint']:checked");
    var result = "";
    $.each(items, function (index, item) {
	   // alert(item)
 	IDS = IDS + "^" + item.RowId;
 	});
	//alert(IDS+"IDS")
	
	
	var selectrow = $("#ItemDetailGrid").datagrid("getRows");//��ȡ�������飬��������
	
	for(var i=0;i<selectrow.length;i++){
		alert(selectrow[i].RowId)
	alert(selectrow[i].TNotPrint.is(':checked'))
	
	}
}
function Chk_Click(ID)
{
	//alert(Type)
	var eSrc = window.event.srcElement;
	//alert(eSrc.checked)
	//alert(ID)
}


///��ȡѡ�е�ҽ���� 
function GetSelectOEORIStr() 
{ 
	var OEORIRowIdStr="";
	var SelectIds=""
	var selectrow = $("#ItemDetailGrid").datagrid("getChecked");//��ȡ�������飬��������
  
	for(var i=0;i<selectrow.length;i++){
		if(selectrow[i].StatDesc==$g("ֹͣ")){
			
			$.messager.alert("��ʾ","ֹͣ��ҽ�������޸�","info");
			return false;
			}
		
	   
		if (OEORIRowIdStr==""){
				OEORIRowIdStr=selectrow[i].OEORIRowId;
			}else{
				OEORIRowIdStr=OEORIRowIdStr+"^"+selectrow[i].OEORIRowId;
			} 
	}
	return OEORIRowIdStr;
	
}


function BUpdateSpec_click()
{
	var OEORIStr=GetSelectOEORIStr()
	
	if(OEORIStr==""){
			$.messager.alert("��ʾ","δѡ������µ�ҽ��!","info");
		    return false;
		}
	if(OEORIStr.split("^").length>1){
		
		$.messager.alert("��ʾ","ֻ�ܲ���һ��ҽ�����±걾!","info");
		return false;
	} 
	var OEORIRowID=OEORIStr.split("^")[0];
	var Source=$("#Source").val();
	var To=$("#To").val();
	if (Source=="")
	{
		top.$.messager.alert("��ʾ","ԭ�걾�Ų���Ϊ��!","info");
		return false;
	}
	if (To=="")
	{
		top.$.messager.alert("��ʾ","���±걾�Ų���Ϊ��!","info");
		return false;
	}
  if(Source==To){
		$.messager.alert("��ʾ","ԭ�걾�ź��±걾��һ��,�������!","info");
		return false;
	}
	
	var flag=tkMakeServerCall("web.DHCPE.BarPrint","IsUpdateSpec",AdmId,To,OEORIRowID);
	
  if(flag=="2"){
		$.messager.alert("��ʾ","���޸�ҽ���Ľ��տ��Һ��±걾�Ľ��տ��Ҳ�һ��,����������!","info");
		return false;
		
	}
	if(flag=="3"){
		$.messager.alert("��ʾ","���޸�ҽ�����������±걾��������һ��,����������!","info");
		return false;
		
	}
	if(flag!="1"){
		$.messager.alert("��ʾ","�±걾�Ų��Ǳ��ξ���ûִ�й��ı걾��,����������!","info");
		return false;
		
   }
	
    var UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.BarPrint","UpdateSpec",Source,To,UserID,OEORIRowID); 
	$.messager.alert("��ʾ","���±걾�ųɹ�!","success");
	$("#To").val("");
	$("#ItemDetailGrid").datagrid('reload'); 
	}
