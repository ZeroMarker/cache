/**
 * ģ��:סԺҩ��
 * ��ģ��:סԺҩ��-��ҳ-��˵�-��ҩ���ά��
 * createdate:2016-06-21
 * creator: yunhaibao
 */

var commonOutPhaUrl = "DHCST.INPHA.ACTION.csp";
var url = "dhcpha.inpha.disptype.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var HospId=session['LOGON.HOSPID'];
var gridChkIcon='<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>'
$(function(){
	InitHospCombo(); //����ҽԺ
	InitDispTypeGrid();	
	InitArcItemCatGrid();	
	$('#btnAdd').on('click',function(){
		$('#disptypewin').window('open');
		$("input[type=checkbox][name=chkcondition]").prop('checked',false);
		$("input[type=text][name=txtcondition]").val("");
	});
	$('#btnSaveCat').on('click',btnSaveCatHandler);
	$('#btnCancel').on('click',function(){
		$('#disptypewin').window('close');
	});
	$('#btnDelete').on('click', btnDeleteHandler);//���ɾ��
	$('#btnUpdate').on('click', btnUpdateHandler);//����޸�
});

//��ʼ����ҩ����б�
function InitDispTypeGrid(){
	//����columns
	var columns=[[
        {field:'tCode',title:'����',width:100},
        {field:'tDesc',title:'����',width:100},
        {field:'tRowid',title:'tRowid',width:100,hidden:true},
        {field:'tOrdType',title:'����',width:100,hidden:true},
        {field:'tPrtDetail',title:'��ӡ��ϸ',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtTotal',title:'��ӡ����',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtOther',title:'��ӡ����',width:100},
        {field:'tReserve',title:'�����ҩ',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tIsPreView',title:'Ԥ����ӡ',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tIsPack',title:'��ɢ��װ��ҩ',width:80,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tReqFlag',title:'�Զ�����ҩ����',width:90,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtResRet',title:'��ӡ�����ҩ��',width:90,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtNoStock',title:'��ӡ��治��',width:80,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        }
	]];  
	
   //����datagrid	
   $('#disptypegrid').datagrid({    
        url:url+'?action=QueryDispType',
        queryParams: {
	        params: HospId
	    },
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
	    singleSelect:true,
	    fit:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    fitColumns:true,
	    onSelect:function(rowIndex,rowData){
		    var chkArcItemCat=""
		    if ($('#chkArcItemCat').is(':checked')){
		    	chkArcItemCat=1
		    }
			$('#arcitemcatgird').datagrid('options').queryParams.params = rowData.tRowid+"^"+chkArcItemCat+"^"+HospId;//����ֵ  
    		$("#arcitemcatgird").datagrid('reload');//���¼���table  
		},
		onLoadSuccess: function(){
         	var txtrowindex=$("#txtRowIndex").val();
         	if (txtrowindex!=""){
	         	$('#disptypegrid').datagrid("selectRow", txtrowindex)
         	}
         	else{
	        	$('#arcitemcatgird').datagrid('loadData',{total:0,rows:[]}); 
				$('#arcitemcatgird').datagrid('options').queryParams.params = ""; 
	        }
         	
	    } 
   });
}
//��ʼ��ҽ�������б�
function InitArcItemCatGrid(){
	//����columns
	var columns=[[
        {field:'tOrdCatRowid',title:'tOrdCatRowid',width:100,hidden:true},
        {field:'tOrdCatCode',title:'ҽ���������',width:100},
        {field:'tOrdCatDesc',title:'ҽ����������',width:300},
        {field:'tDispCat',title:'������ҩ���',width:200},
        {field:'tSelect',title:'ѡ��',width:50,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
	    },
        {field:'tWholeDisp',title:'����֧��ҩ',width:100,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        }
	]];  
	
   //����datagrid	
   $('#arcitemcatgird').datagrid({    
        url:url+'?action=QueryArcItemCat',
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
	    singleSelect:true,
	    fit:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    onClickRow:function(rowIndex,rowData){

		},
		onDblClickCell: function (rowIndex, field, value) {
			if ((field!="tSelect")&&(field!="tWholeDisp")){return;}
			var disptypeselect=$("#disptypegrid").datagrid('getSelected');
			if (disptypeselect==null){
				return;
			}
			var disptypedesc=disptypeselect["tDesc"];
			var disptypeid=disptypeselect["tRowid"];
			var arccatselect=$('#arcitemcatgird').datagrid('getData').rows[rowIndex];			
			var arcitemcat=arccatselect["tOrdCatDesc"];
			var olddisptype=arccatselect["tDispCat"];
			var arcitemcatid=arccatselect["tOrdCatRowid"];
			var wholedisp=arccatselect["tWholeDisp"];
			if ((olddisptype=="")||(olddisptype==undefined)){
				olddisptype="";
			}
			if (field=="tSelect"){
				if (olddisptype==disptypedesc){
					$.messager.alert("��ʾ","�ĺ������ԭ���һ��,�����޸�!","info")
					return;
				}
				var msginfo="<p>ҽ������:<font color=blue><b>"+arcitemcat+"</b></font></p>"+
							"<p>��ҩ���:<font color=blue><b>"+olddisptype+"=>"+disptypedesc+"</b></font></p>"
				$.messager.confirm('�Ƿ�ȷ���޸�?', msginfo, function(r) {
			    	if(r==true){
				    	var insret=tkMakeServerCall("web.DHCINPHA.DispType","SaveCatSub",disptypeid,arcitemcatid)
				    	if (insret<0){
							$.messager.alert("��ʾ","�޸�ʧ��,�������:"+insret,"warning")
							return;
					    }else{
						    var columns = $('#arcitemcatgird').datagrid("options").columns;
						    var columnsstr=$('#arcitemcatgird').datagrid('getColumnFields',false);
   							var selectNum=columnsstr.indexOf("tSelect");
   							var dispcatNum=columnsstr.indexOf("tDispCat");
							arccatselect[columns[0][dispcatNum].field]=disptypedesc;
							arccatselect[columns[0][selectNum].field]=1;
							$('#arcitemcatgird').datagrid('refreshRow', rowIndex);							
						}
				    }else{
						return;
					}
				});
			}else if (field=="tWholeDisp"){
				if (arccatselect.tSelect==0){
					$.messager.alert("��ʾ","ҽ�����಻�ڵ�ǰѡ�еķ�ҩ�����!","info")
					return;					
				}				
				var msginfo="<p>ҽ������:<font color=blue><b>"+arcitemcat+"</b></font></p>"
				var msginfo1="<p>���޸�Ϊ:<font color=blue><b>����֧��ҩ</b></font></p>"
				if (wholedisp=="1"){
					msginfo1="<p>ȡ������:<font color=blue><b>����֧��ҩ</b></font></p>"
					wholedisp="0"
				}else{
					wholedisp="1"
				}
				msginfo=msginfo+msginfo1
				$.messager.confirm('�Ƿ�ȷ���޸�?', msginfo, function(r) {
			    	if(r==true){
				    	var insret=tkMakeServerCall("web.DHCINPHA.DispType","SaveWholeDispConfig",arcitemcatid,wholedisp)
				    	if (insret<0){
					    	if (insret=="-1"){
						    	$.messager.alert("��ʾ","����ά��ҽ������ķ�ҩ���!","info")
								return;
						    }else{					    	
								$.messager.alert("��ʾ","�޸�ʧ��,�������:"+insret,"warning")
								return;
						    }
					    }else{
						    var columns = $('#arcitemcatgird').datagrid("options").columns;
						    var columnsstr=$('#arcitemcatgird').datagrid('getColumnFields',false);
   							var wholeNum=columnsstr.indexOf("tWholeDisp");
							arccatselect[columns[0][wholeNum].field]=wholedisp;
							$('#arcitemcatgird').datagrid('refreshRow', rowIndex);							
						}
				    }else{
						return;
					}
				});

			}
		}
  
   });
}

///��ҩ���ɾ��
function btnDeleteHandler(){
	var seletcted = $("#disptypegrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('��ʾ',"����ѡ����ɾ������!","info");
		return;
	}
	var disptypeid=seletcted.tRowid;
	var disptypedesc=seletcted.tDesc;
	var msginfo="<p>��ҩ���:<font color=blue><b>"+disptypedesc+"</b></font></p>"+
				"<p><font color=red><b>��ȷ���÷�ҩ�����δ��ҽ��,��������!</b></font></p>"	
	$.messager.confirm('ȷ��ɾ����',msginfo,function(r){
		if(r){
			$.messager.confirm('�ٴ�ȷ���Ƿ���Ҫɾ����','��ҩ���ΪסԺ��ҩ��������!',function(r1){
				if (r1){
					var delret=tkMakeServerCall("web.DHCSTPHADRUGGROUP","DeleteMast",disptypeid,HospId);
					if(delret>0){
						$('#disptypegrid').datagrid('reload');
					}
					else{
						$.messager.alert('��ʾ',"ɾ��ʧ��!");
					}
				}
			})
			
		}
	});
}
//���淢ҩ���
function btnSaveCatHandler(){
	var rowid=$.trim($("#txtRowId").val());
	var code=$.trim($("#txtCode").val());
	var desc=$.trim($("#txtDesc").val()); 
	if (code==""){
		$.messager.alert('��ʾ',"����Ϊ��!","info");
		return;
	}
	if(desc==""){
		$.messager.alert('��ʾ',"����Ϊ��!","info");
		return;
	}
	var prtOther=$.trim($("#txtPrtOther").val());
  	var prtTotal=0;prtDetail=0;ispack=0;reserve=0,reqflag=0;
  	var prtResRet=0,isPreView=0,prtNoStock=0;
	if ($("#chkPrtTotal").is(':checked')){
		prtTotal="1"
	}
	if ($("#chkPrtDetail").is(':checked')){
		prtDetail="1"
	}
	if ($("#chkIsPack").is(':checked')){
		ispack="1"
	}
	if ($("#chkReserve").is(':checked')){
		reserve="1"
	}
	if ($("#chkReqFlag").is(':checked')){
		reqflag="1"
	}
	if ($("#chkPrtResRet").is(':checked')){
		prtResRet="1"
	}
	if ($("#chkIsPreView").is(':checked')){
		isPreView="1"
	}
	if ($("#chkPrtNoStock").is(':checked')){
		prtNoStock="1"
	}
	var ConfigStr=code+"^"+prtDetail+"^"+prtTotal+"^"+prtOther+"^"+prtResRet+"^"+isPreView+"^"+prtNoStock
	var ConfigStr=ConfigStr+"@"+ispack+"@"+reserve+"@"+reqflag+"@"+HospId;
	var ret=""
	if (rowid>0){
		ret=tkMakeServerCall("web.DHCSTPHADRUGGROUP","UpdateMast",rowid,code,desc,ConfigStr)
	}else{
		ret=tkMakeServerCall("web.DHCSTPHADRUGGROUP","InsertMast",code,desc,ConfigStr)
	}
	var retArr=ret.split("^");
	if (retArr[0]<0) {
		if ((retArr[1]!="")&&(retArr[1]!=undefined)){
			$.messager.alert('��ʾ',retArr[1],"warning");
		}else{
			$.messager.alert('��ʾ',"����ʧ��,�������:"+ret,"error");
		}
		return ;	
	}else{
		$('#disptypewin').window('close');
		$('#disptypegrid').datagrid('reload');
	}	

}
//�޸ķ�ҩ���
function btnUpdateHandler(){
	var seletcted = $("#disptypegrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('��ʾ',"����ѡ�����޸ĵ���!","info");
		return;
	}
	var selectrow=$('#disptypegrid').datagrid("getRowIndex",seletcted);
	$('#disptypewin').window('open');
	$("input[type=checkbox][name=chkcondition]").prop('checked',false);
	$("input[type=text][name=txtcondition]").val("");
	$("#txtRowId").val(seletcted.tRowid);
	$("#txtCode").val(seletcted.tCode);
	$("#txtDesc").val(seletcted.tDesc);
	$("#txtRowIndex").val(selectrow);
	$("#txtPrtOther").val(seletcted.tPrtOther);
	if (seletcted.tPrtTotal=="1"){
		$('#chkPrtTotal').prop('checked',true); 
	}
	if (seletcted.tPrtDetail=="1"){
		$('#chkPrtDetail').prop('checked',true); 
	}
	if (seletcted.tIsPack=="1"){
		$('#chkIsPack').prop('checked',true); 
	}
	if (seletcted.tReserve=="1"){
		$('#chkReserve').prop('checked',true); 
	}
	if (seletcted.tReqFlag=="1"){
		$('#chkReqFlag').prop('checked',true); 
	}
	if (seletcted.tPrtResRet=="1"){
		$('#chkPrtResRet').prop('checked',true); 
	}
	if (seletcted.tIsPreView=="1"){
		$('#chkIsPreView').prop('checked',true); 
	}
	if (seletcted.tPrtNoStock=="1"){
		$('#chkPrtNoStock').prop('checked',true); 
	}
}


function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'DHCStkDrugGroup'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#disptypegrid').datagrid({    
			        queryParams: {
				        params: HospId
				    }
				});				
				$('#arcitemcatgird').datagrid('loadData',[]);				
			}
        };
	}
}