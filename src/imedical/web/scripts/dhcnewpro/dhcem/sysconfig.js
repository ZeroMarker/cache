///CreatDate:  2016-06-07
///Author:    huaxiaoying 
var SAtypeID="";//ȫ�ֱ�������Ʒ������Ȩ��(���)������id
var HospDr="";//ȫ�ֱ�������Ʒ��(����)��ҽԺid
//var SAId=""//ȫ�ֱ���:����id
var editRowF=0//ȫ�ֱ���������˫���༭index //add hxy 2016-08-06
var editRow=0//ȫ�ֱ������ӱ�˫���༭index //add hxy 2016-08-06
var SId=getParam("SAAId"); //add liyarong
///add liyarong ����shift+q������Ȩ���ʹ���
 $(document).keypress(function(event){ 
    if(event.shiftKey && event.keyCode==81){
	     addSecFlag();
	  }
  });

$(function(){
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
	
	$.extend($.fn.datagrid.defaults.editors,{ //huaxiaoying 2018-02-06 st ����༭ʱ�ļ���
	      password: {//datetimebox������Ҫ�Զ���editor������
	         init: function(container, options){
		        var row =$("#datagrid1").datagrid('getSelected');
				var inputType="text";
				if(row.SYCode.indexOf("PASSWORD")!=-1){
					inputType="password";
				}
	             var input = $('<input style="border:none;width:100%" type="'+inputType+'" class="textbox">').appendTo(container);
	             return input
	         },
	         getValue: function(target){
	             return $(target).val();
	        },
	         setValue: function(target, value){
	             $(target).val(value);
	         },
	         resize: function(target, width){
	         }
	     }
	});
	
	//��ʶ�󶨻س��¼�
     $('#SYGroupName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
     
    $('#SAHospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 
	 $('#queryBTN').on('click',function(){
		 commonQuery({'datagrid':'#datagrid2','formid':'#toolbar2'}); //���ò�ѯ
	 }) //hxy ed
	 
	 //���������󶨻س��¼� 2021-04-03 st
     $('#SYICode,#SYIDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid1','formid':'#queryForm1'}); //���ò�ѯ
        }
     }); //ed
	// �˵��������-��Ʒ���ʶ��ֵ
	if(SYGroupNameFlag!=""){
		$('#SYGroupNameFlag').val(SYGroupNameFlag);
		commonQuery({'datagrid':'#datagrid','formid':'#queryForm'});
	}
});

/// ��������Ȩ��ʶ
function addSecFlag(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��Ʒ��');
		return;
	}
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��Ʒ���ܱ�');
		return;
	}
	var row =$("#datagrid1").datagrid('getSelected');
	if(row){
		$('#sysWin').window({
		     title:'��Ȩ����',
		     collapsible:false,
		     minimizable:false,
		     maximizable:false,
		     border:true,
		     closed:'true',
		     width:'220',
		     height:300
		});
		var CurToken=""; //hxy 2023-02-23 st
		if ('undefined'!==typeof websys_getMWToken){
			CurToken="&MWToken="+websys_getMWToken()
		}
		var iframe='<iframe scrolling="yes" width=100% height=100%  id="sysIframe" frameborder="0" src="dhcem.sysWin.csp?SAAId='+row.ID+CurToken+'"></iframe>'; //ed
		$('#sysWin').html(iframe);       
		$('#sysWin').window('open');   
	}    
}


///csp���������ֵ����
function fillValue(rowIndex, rowData){
	$('#datagrid2').datagrid('getRows')[editIndex]['SAPointer']=rowData.id
}

///������ ��Ʒ��(����) 
function addRowSys(){
	commonAddRow({'datagrid':'#datagrid',value:{'SYActiveFlag':'Y'}}) //hxy 2019-06-21 ���������ҽԺ���ò�����ȥ����,'SYHospDr':'2'
}
///˫���༭ ��Ʒ��(����) 
function onClickRowSys(index,row){
	editRowF=index //add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid");
	$("#Hosp").attr("formatter",row.SYHospDr.HOSPDesc);
}
///�����༭ ��Ʒ��(����) 
function ClickRowSys(){
	var row =$("#datagrid").datagrid('getSelected');
	SAId=row.ID; ///��id
	$("#labelInfo").html("");
	
	$('#datagrid1').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItm&MethodName=ListSysItm&SAId='+SAId,
		queryParams:{
			LabelDesc:""	
		}
	});
	$('#datagrid2').datagrid({  //add hxy 2016-08-06
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
	}
///���� ��Ʒ��(����) 
function saveSys(){
	saveByDataGrid("web.DHCEMSys","SaveSys","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('load')
				$("#datagrid2").datagrid('load')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
	$('#datagrid1').datagrid({  //add hxy 2016-08-06
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
	
}

///ɾ�� ��Ʒ��(����) 
function cancelSys(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSys","RemoveSys",{'Id':row.ID},function(data){ 
		 $('#datagrid').datagrid('load');
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}
///���ð�ť���� //add hxy 2016-08-06
function Reload(){
	$('#SYGroupName').val("");
	commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
//	$('#datagrid').datagrid('load');
	$('#datagrid1').datagrid({  
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
}

///������ ��Ʒ���ܱ�(�ӱ�) 
function addRowSysItm(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��Ʒ��');
		return;
	 }
	 $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
	 var row =$("#datagrid").datagrid('getSelected');
	 SAId=row.ID; ///��id  
	 
	commonAddRow({'datagrid':'#datagrid1',value:{'SYRemark':'','SYParRefDr':SAId}})
}
///˫���༭ ��Ʒ���ܱ�(�ӱ�)
function onClickRowSysItm(index,row){
    editRow=index //add hxy 2016-08-06
    $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid1");
}
///�����༭ ��Ʒ���ܱ�(�ӱ�)
function ClickRowSysItm(){
	var row =$("#datagrid1").datagrid('getSelected');
	SAItmId=row.ID; ///�ӱ�id
	$('#datagrid2').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAut&SAItmId='+SAItmId
	});
	}
///���� ��Ʒ���ܱ�(�ӱ�)
function saveSysItm(){
	saveByDataGrid("web.DHCEMSysItm","SaveSysItm","#datagrid1",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});
	$('#datagrid2').datagrid({  //add hxy 2016-08-06
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
			
}

///ɾ�� ��Ʒ���ܱ�(�ӱ�)
function cancelSysItm(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItm","RemoveSysItm",{'Id':row.ID},function(data){ 
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///������ ��Ʒ������Ȩ��(���)
function addRowSysItmAut(index){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��Ʒ��');
		return;
	 }
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��Ʒ���ܱ�');
		return;
	 }
    $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
    $("#datagrid1").datagrid('endEdit', editRow);//add hxy 2016-08-08
	var row =$("#datagrid1").datagrid('getSelected');
	SAid=row.ID; ///�ӱ�id
	
	var rows =$("#datagrid").datagrid('getSelected');
	HospDr=rows.SYHospDrID; ///����ҽԺid
	  
	commonAddRow({'datagrid':'#datagrid2',value:{'SAHospDr':LgHospDesc,'SAHospDrID':LgHospID,'SAParRefDr':SAid}}) //hxy 2019-07-26//,'SAHospDr':HospDr ///cy 2021-02-08 ҽԺ������id�ֶηֿ�
	//SAtypeID="G";
    
    var rowIndex=$('#datagrid2').datagrid('getRowIndex',$('#datagrid2').datagrid('getSelected'))
	var varEditor = $('#datagrid2').datagrid('getEditor', { index: index, field: 'SAType' });

	$(varEditor.target).combobox( { 
				url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListIsWhich&SID='+SAid

	})
    
    
    
}

///˫���༭ ��Ʒ������Ȩ��(���)
function onClickRowAut(index,row){
	$("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
	$("#datagrid1").datagrid('endEdit', editRow);//add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid2");
	//$("#Hosp1").attr("formatter",row.SAHospDr.HOSPDesc);
	//return;
	SAtypeID=row.SAType
	var rowIndex=$('#datagrid2').datagrid('getRowIndex',$('#datagrid2').datagrid('getSelected'))
	var varEditor = $('#datagrid2').datagrid('getEditor', { index: rowIndex, field: 'PointerDesc' });

	HospDR=row.SAHospDrID

	//add liyarong
	var varEditor1 = $('#datagrid2').datagrid('getEditor', { index: rowIndex, field: 'SAType' }); 
    var row1 =$("#datagrid1").datagrid('getSelected');
	var SAid=row1.ID; ///�ӱ�id
    $(varEditor1.target).combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListIsWhich&SID='+SAid   
	    })

	$(varEditor1.target).combobox('setValue', row.SAType);
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListGroup&type='+SAtypeID+'&HospDr='+HospDR
	})
	$(varEditor.target).combogrid('setValue', row.PointerDesc);
		
}
///���� ��Ʒ������Ȩ��(���)
function saveSysItmAut(){
	saveByDataGrid("web.DHCEMSysItmAut","SaveSysItmAut","#datagrid2",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid2").datagrid('load')
			}else if(data==1){
				$.messager.alert("��ʾ","����ֵ�Ѵ���,�����ظ�����!"); 
				$("#datagrid2").datagrid('load')
			}else if(data==2){
				$.messager.alert("��ʾ","�ֶ�¼����Ч,������ѡ��!"); 
				$("#datagrid2").datagrid('load')
			}else if(data==3){
				$.messager.alert("��ʾ","�밴Ҫ��ά��!"); 
				$("#datagrid2").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	

}

///ɾ�� ��Ʒ������Ȩ��(���)
function cancelSysItmAut(){
	
	if ($("#datagrid2").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid2").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItmAut","RemoveSysItmAut",{'Id':row.ID},function(data){ $('#datagrid2').datagrid('load'); })
    }    
}); 
}
///sufan 2019-11-08  ��������grid����
function reloadTypeList()
{
	var typeEditor = $('#datagrid2').datagrid('getEditor', { index: editIndex, field: 'SAType' });
	var SAtypeID=$(typeEditor.target).combobox('getValue');
	var typevalEditor = $('#datagrid2').datagrid('getEditor', { index: editIndex, field: 'PointerDesc' });
	var hospEditor = $('#datagrid2').datagrid('getEditor', { index: editIndex, field: 'SAHospDrID' }); ///cy 2021-02-08 ҽԺ������id�ֶηֿ�
	var HospDr=$(hospEditor.target).val();//$(hospEditor.target).combobox('getValue'); ///cy 2021-02-08 ҽԺ������id�ֶηֿ�
	var SAtypeID=$(typeEditor.target).combobox('getValue');
	$(typevalEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListGroup&type='+SAtypeID+'&HospDr='+HospDr
    })
}

///���ð�ť���� //add hxy 2021-04-03
function ReloadItm(){
	$('#SYICode').val("");
	$('#SYIDesc').val("");
	commonQuery({'datagrid':'#datagrid1','formid':'#queryForm1'}); //���ò�ѯ
}

/// ��Ȩ����
function AutTypeWin(){
	addSecFlag();
	return;
}

function formatLabel(value,row,index){
	
	return value;
	
	var itmHtml=""
	+"<div class='labelDiv'>"
		+"<span class='labelItm'>"
			+"<span class='labelSpan' onClick='sysUpdLabel(this)'>��ǩ1</span>"
			+"<span onClick='deleteUpdLabel(this)'>��</span>"
		+"</span>"
		+"<span class='addLabel' onClick='sysAddLabel(this)'>+</span>"
	+"</div>";
	return itmHtml;
}

function sysAddLabel(_this){
	
}


function showThisLabel(_this){
	if(!$(_this).hasClass("checkLabel")){
		$(".checkLabel").length?$(".checkLabel").removeClass("checkLabel"):"";
	}
	$(_this).toggleClass("checkLabel");
	var labelDesc=($(".checkLabel").length?$(".checkLabel").html():"")
	$HUI.datagrid('#datagrid1').load({
		SYICode:$("#SYICode").val(),
		SYIDesc:$("#SYIDesc").val(),
		SAId:"",
		LabelDesc:labelDesc
	})
	return;
}

function SysItmSuccess(jsonData){
	showLabelItm(jsonData.labelList);
}

function showLabelItm(labelList){
	if($("#SYICode").val()) return;
	if($("#SYIDesc").val()) return;
	if($(".checkLabel").length) return;
	
	var allLabelHtml="";
	for (i in labelList){
		var labelItm=labelList[i];
		var itmHtml=""
			+"<span class='sysLabel' onClick='showThisLabel(this)'>"
			+	labelItm.SYLabel
			+"</span>"
		allLabelHtml+=itmHtml;
	}
	$("#labelInfo").html(allLabelHtml);
}

			      	