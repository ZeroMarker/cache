///CreatDate��   2017-12-10 
///Creator��    huaxiaoying
var EditRow="0";   //add by sufan 2018-07-16
var hospID="";
$(function(){ 
    //��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
    InitHosp(); 
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
});
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvSecuGroup"); 
	hospID=hospComp.getValue();
	//hospComp.setValue("ȫ��"); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///ѡ���¼�
 		hospID=hospComp.getValue();
		QueryBtn();
	}
}

function InitDefault(){ 
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
	
	//ͬʱ������������󶨻س��¼�
     $('#SECUCode,#SECUDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
    $('#WardW,#UserW,#LocW').window('close');  //2018-01-12 cy ��ӷֹܿ���
	loadHtml();
	QueryBtn();
	
};

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'SECUActiveFlag':'Y','SECUHospDr':hospID}})
}
//˫���༭
function onDblClickRow(index,row){
	EditRow=index;
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCADVSecuGroup","SaveSecuGro","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("��ʾ","�����ѱ�������ʹ�ã������޸������Ƿ������!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}

///ɾ����Ա
function deleteUser(id){
	//alert(id)
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ���ó�Ա��',function(r){    
    	if (r){   
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGroU",{'Id':id},function(data){ 
		 	reloadHtml();///���¼��ع������ 
		 })
    	}  
    });
}
///ɾ������
function deleteWard(id){
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ���ò�����',function(r){    
    	if (r){   
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGroUW",{'Id':id},function(data){ 
		 	reloadHtml();///���¼��ع������ 
		 })
    	}  
	});
}
///��Ӱ�ȫС���Ա
function addUser(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��ȫС���ֵ��');
		return;
	}
	if($("#datagrid").datagrid('getSelected').ID==undefined){ //hxy 2020-03-19 st
		$.messager.alert('��ʾ','����ѡ����Ч ��ȫС���ֵ�� ��¼');
		return;
	} //ed
	$("#datagrid").datagrid('endEdit', EditRow); 
	$('#UserW').panel({title: "����С���Ա"});
	$('#UserW').window('open');
    $('#gridUser').datagrid('loadData',{total:0,rows:[]});
	addUserAdd();
	/*var row =$("#datagrid").datagrid('getSelected');
	SECURowId=row.ID; ///�ӱ�id
	commonAddRow({'datagrid':'#gridUser',value:{'SECUGrpDr':SECURowId,'SECULeadFlag':'N'}})
    var rowIndex=$('#gridUser').datagrid('getRowIndex',$('#gridUser').datagrid('getSelected'))
	var varEditor = $('#gridUser').datagrid('getEditor', { index: rowIndex, field: 'SECUUser' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListUser&HospDr='+LgHospID
	})	*/
}
//˫���༭��Ա
function onDblClickRowUser(index,row){
	CommonRowClick(index,row,"#gridUser");
	var varEditor = $('#gridUser').datagrid('getEditor', { index: index, field: 'SECUUser' });
	$(varEditor.target).combogrid({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListUser&SECURowId='+SECURowId+'&HospID='+hospID
	})
		$(varEditor.target).combogrid('setValue',row.SECUUser);
}
///��Ӱ�ȫС���Ա-����
function addUserAdd(){
	var row =$("#datagrid").datagrid('getSelected');
	SECURowId=row.ID; ///�ӱ�id
	commonAddRow({'datagrid':'#gridUser',value:{'SECUGrpDr':SECURowId,'SECULeadFlag':'N'}})
    var rowIndex=$('#gridUser').datagrid('getRowIndex',$('#gridUser').datagrid('getSelected'))
	var varEditor = $('#gridUser').datagrid('getEditor', { index: rowIndex, field: 'SECUUser' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListUser&SECURowId='+SECURowId+'&HospID='+hospID
	})	
}
///�޸ĳ�Ա
function updateUser(id){
	var row =$("#datagrid").datagrid('getSelected');
	SECURowId=row.ID; ///�ӱ�id
		$('#UserW').panel({title: "�޸�С���Ա"});
		$('#UserW').window('open');	
	$('#gridUser').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=selUser&id='+id
	});			
}
///�����Ա
function fillValue(rowIndex, rowData){
	$('#gridUser').datagrid('getRows')[editIndex]['SECUUserDr']=rowData.id;
}
///���氲ȫС���Ա
function saveSecuGU(){
	saveByDataGrid("web.DHCADVSecuGroup","saveSecuGU","#gridUser",function(data){
		if(data==0){
			$('#UserW').window('close');
			reloadHtml();
			$.messager.alert("��ʾ","����ɹ�!");
			//$("#gridUser").datagrid('load')
		}else if(data==1){
			$.messager.alert("��ʾ","�Ѵ���,�����ظ�����!"); 
			//$("#gridUser").datagrid('load')
		}else if(data==2){
			$.messager.alert("��ʾ","�ֶ�¼����Ч,��ѡ��!"); 
			//$("#gridUser").datagrid('load')
		}else if(data==3){ //huaxiaoying 2018-02-07
			$.messager.alert("��ʾ","ֻ�������һ���鳤!"); 
		}else{	
			$.messager.alert('��ʾ','����ʧ��:'+data)
			
		}
	});	
}

///��Ӱ�ȫС��ֹܲ���
function addWard(Drs){
	$('#WardW').window('open');	
	$("#Drs").val(Drs);
	$('#gridWard').datagrid('loadData',{total:0,rows:[]});
	addWardAdd();	
}
///��Ӱ�ȫС���Ա����-����
function addWardAdd(){
	var Drs=$("#Drs").val();
	$("#datagrid").datagrid('endEdit', EditRow); 
	commonAddRow({'datagrid':'#gridWard',value:{'SECUDrs':Drs}})
    var rowIndex=$('#gridWard').datagrid('getRowIndex',$('#gridWard').datagrid('getSelected'))
	var varEditor = $('#gridWard').datagrid('getEditor', { index: rowIndex, field: 'SECUWard' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListWard&HospID='+hospID
	})
	
}
///��Ӳ���
function fillValueWard(rowIndex, rowData){
	$('#gridWard').datagrid('getRows')[editIndex]['SECUWardDr']=rowData.id
}
//˫���༭����
function onDblClickRowWard(index,row){
	
	CommonRowClick(index,row,"#gridWard");
	var rowIndex=$('#gridWard').datagrid('getRowIndex',$('#gridWard').datagrid('getSelected'))
	var varEditor = $('#gridWard').datagrid('getEditor', { index: index, field: 'SECUWard' });
	var WardText=varEditor.oldHtml;
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListWard&HospID='+hospID
	})
	$(varEditor.target).combogrid("setValue", WardText); 
}
///���氲ȫС��ֹܲ���
function saveSecuGUW(){
	saveByDataGrid("web.DHCADVSecuGroup","saveSecuGUW","#gridWard",function(data){
		if(data==0){
			$('#WardW').window('close');
			reloadHtml();
			$.messager.alert("��ʾ","����ɹ�!");
		}else if(data==1){
			$.messager.alert("��ʾ","�Ѵ���,�����ظ�����!"); 
		}else if(data==2){
			$.messager.alert("��ʾ","�ֶ�¼����Ч,��ѡ��!"); 
		}else{	
			$.messager.alert('��ʾ','����ʧ��:'+data)
			
		}
	});	

	
}

function onClickRow(index,row){
	var row =$("#datagrid").datagrid('getSelected'); 
	toHtml(row.ID);    
    //var LinkUrl = "dhcadv.secugroupuser.csp?Id="+row.ID;
	//$("#TabMain").attr("src", LinkUrl);
}
///��ʼ����ʾ�Ҳ�
function loadHtml(){	
	var html=""
	$("#itemList").html(""); //hxy 2020-03-19
   // html+='<table id=""  border="1" style="width:640px" cellspacing="0" cellpadding="1" class="form-table" headerCls="panel-header-gray">'
    
    //html+='<thead>'
    //html+='<tr>'
	//html+='	<td width=30>ɾ����Ա</td><td width=60>��ȫС���Ա</td><td>�ֹܲ���</td><td style="width:60px">��Ӳ���</td><td>�ֹܿ���</td><td style="width:60px">��ӿ���</td><td width=40>�鳤</td>'  //2018-01-12 cy ��ӷֹܿ���
    //html+='</tr>'
   // html+='</thead>'
   // html+='</table>';
   // $("#itemList").html("");
   // $("#itemList").append(html);
}
///����html
function reloadHtml(){
	var row =$("#datagrid").datagrid('getSelected'); 
	toHtml(row.ID);    
}
///����html
function toHtml(Id){
    var html=""
    //html+='<table id=""  border="1" style="width:640px" cellspacing="0" cellpadding="1" class="form-table">'
   // html+='<thead style="position:absolute;background:#CCCCCC;">'
   // html+='<tr>'
	//html+='	<td width=30>ɾ����Ա</td><td width=60>��ȫС���Ա</td><td>�ֹܲ���</td><td style="width:60px">��Ӳ���</td><td>�ֹܿ���</td><td style="width:60px">��ӿ���</td><td width=40>�鳤</td>'      //2018-01-12 cy ��ӷֹܿ���
   // html+='</tr>'
	//html+='</thead>'
	runClassMethod("web.DHCADVSecuGroup","ToHtml",
		{'GrpDr':Id},
		 function(data){
			 var strArray=data.split("!!");
			 for (var i=0;i<strArray.length-1;i++)
			 {
				var trStr=strArray[i];
				if(trStr==undefined){return;}
				var trArray=trStr.split("^");
				html+='<tr>';
				html+='<td style="width:25px;"><a id="'+trArray[0]+'"  class="img icon-cancel" onclick="deleteUser(this.id)" title="ɾ��"></a></td>';
			    html+='<td style="width:50px;max-width:50px;" ondblclick="updateUser('+trArray[0]+')">'+trArray[1]+'</td>' //hxy 2020-03-19 max-width:50px;
				
				html+='<td style="width:150px;">'
				if(trArray==""){wardHtml=""}
				var wardHtml=""
				if(trArray[4]==""){
					wardHtml=""
				}else{
					var GUWArray=trArray[4].split("||");
					for (var j=0;j<GUWArray.length-1;j++)
					{
						var WardStr=GUWArray[j];
						var tdArray=WardStr.split("*");
						if(j>0){
							wardHtml+='<br style="line-height:28px">';	
						}
			        	wardHtml+='<div style="float:left">';		
			        	wardHtml+='	<span id="'+tdArray[0]+'" class="img icon-no" onclick="deleteWard(this.id)" style="float:left" title="ɾ��"></span><span class="warditm">'+tdArray[1]+'</span>';				
						wardHtml+='</div>';	
						
					}
				}
				html+=wardHtml
				html+='</td>'
				//2018-01-12 cy ��ӷֹܿ���
				html+='<td style="width:25px;"><a id="'+trArray[3]+'" class="img icon-add" onclick="addWard(this.id)" title="����"></a></td>';
				
				html+='<td style="width:150px;">'
				if(trArray==""){LocHtml=""}
				var LocHtml=""
				if(trArray[5]==""){
					LocHtml=""
				}else{
					var GULArray=trArray[5].split("||");
					for (var j=0;j<GULArray.length-1;j++)
					{
						var LocStr=GULArray[j];
						var tdArray=LocStr.split("*");
						if(j>0){
							LocHtml+='<br style="line-height:28px">';	
						}
			        	LocHtml+='<div style="float:left">';		
			        	LocHtml+='	<span id="'+tdArray[0]+'" class="img icon-no" onclick="deleteLoc(this.id)" style="float:left" title="ɾ��"></span><span class="Locitm">'+tdArray[1]+'</span>';				
						
						LocHtml+='</div>';	
					}
				}
				html+=LocHtml
				html+='</td>'
				html+='<td style="width:25px;"><a id="'+trArray[3]+'" class="img icon-add" onclick="addLoc(this.id)" title="����"></a></td>';
				if(trArray[2]=="N"){
			        html+='<td style="width:25px;"><input id="'+trArray[0]+'" class="checkbox" type="checkbox" name="" value="Y" onclick="updateLeadFlag(this)"></input></td>';	 //hxy 2018-02-07
			    }else{
					html+='<td style="width:25px;"><input id="'+trArray[0]+'" class="checkbox" type="checkbox" name="" value="N" checked onclick="updateLeadFlag(this)"></input></td>';	 //hxy 2018-02-07
				}  
				html+='</tr>';
			 }//��һ��forѭ������
	 	    // html+='</table>';
	 	     $("#itemList").html("");
	         $("#itemList").append(html);
	});


}

///huaxiaoying 2018-02-07 �Ҳ��鳤��checkbox���ø�������
function updateLeadFlag(option){
	runClassMethod("web.DHCADVSecuGroup","UpdateGUByLeadFlag",{'Id':option.id,'LeadFlag':option.value},function(data){ 
		if(data==3){
			$.messager.alert('��ʾ','ֻ�������һ���鳤!');
		}
		reloadHtml();
	})
	
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	if($("#datagrid").datagrid('getSelected').ID==undefined){ //hxy 2020-03-19 st
		$("#datagrid").datagrid('deleteRow', EditRow);
		return;
	} //ed
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGro",{'Id':row.ID},function(data){ 
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$('#datagrid').datagrid('load');
		 		loadHtml();
			}else if(data=="-2"){
				$.messager.alert('��ʾ','�����ݱ����������ã�����ɾ��');
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
		 	 
		 })
    }    
});
}

///�ֹܿ��� ��س���  cy  2018-01-12 
///��Ӱ�ȫС��ֹܿ���
function addLoc(LocDrs){
	$('#LocW').window('open');	
	$("#LocDrs").val(LocDrs);
	$('#gridLoc').datagrid('loadData',{total:0,rows:[]});
	addLocAdd();	
}
///��Ӱ�ȫС���Ա����-����
function addLocAdd(){
	var LocDrs=$("#LocDrs").val();
	$("#datagrid").datagrid('endEdit', EditRow); 
	commonAddRow({'datagrid':'#gridLoc',value:{'SECUGULDrs':LocDrs}})
    var rowIndex=$('#gridLoc').datagrid('getRowIndex',$('#gridLoc').datagrid('getSelected'))
	var varEditor = $('#gridLoc').datagrid('getEditor', { index: rowIndex, field: 'SECUGULLoc' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListLoc&HospID='+hospID
	})
	
}
///��ӿ���
function fillValueLoc(rowIndex, rowData){
	$('#gridLoc').datagrid('getRows')[editIndex]['SECUGULLocDr']=rowData.id

}

//˫���༭����
function onDblClickRowLoc(index,row){
	CommonRowClick(index,row,"#gridLoc");
	var rowIndex=$('#gridLoc').datagrid('getRowIndex',$('#gridLoc').datagrid('getSelected'))
	var varEditor = $('#gridLoc').datagrid('getEditor', { index: rowIndex, field: 'SECUGULLoc' });
	var LocText=varEditor.oldHtml;
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListLoc&HospID='+hospID
	})
	$(varEditor.target).combogrid("setValue", LocText); 
	
	
}
///���氲ȫС��ֹܿ���
function saveSecuGUL(){
	saveByDataGrid("web.DHCADVSecuGroup","saveSecuGUL","#gridLoc",function(data){
		if(data==0){
			$('#LocW').window('close');
			reloadHtml();
			$.messager.alert("��ʾ","����ɹ�!");
		}else if(data==1){
			$.messager.alert("��ʾ","�Ѵ���,�����ظ�����!"); 
		}else if(data==2){
			$.messager.alert("��ʾ","�ֶ�¼����Ч,��ѡ��!"); 
		}else{	
			$.messager.alert('��ʾ','����ʧ��:'+data)
			
		}
	});	
	
}
///ɾ������
function deleteLoc(id){
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ���ÿ�����',function(r){    
    	if (r){   
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGroUL",{'Id':id},function(data){ 
		 	reloadHtml();///���¼��ع������ 
		 })
    	}  
	});
}
///2018-02-01 cy ���Ӳ�ѯ��ť,���ð�ť���ӷ���,
function QueryBtn(){
	commonQuery({'datagrid':'#datagrid','formid':'#queryForm'});
	loadHtml();
}
function ReloadBtn(){
	commonReload({'datagrid':'#datagrid','formid':'#queryForm'})
	loadHtml();
}
//ɾ�������б�  sufan 2018-05-22
function cancelWard()
{
	var select=$('#gridWard').datagrid('getSelected');
	if(select == null){
		$.messager.alert('��ʾ','��ѡ��');
		return false;
	}
	var index=$('#gridWard').datagrid('getRowIndex',select);
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ���ò�����',function(r){    
    	if (r){   
		$('#gridWard').datagrid('deleteRow',index);
    	}  
	});
	
}
//ɾ�������б�  sufan 2018-05-22
function cancelLoc()
{
	var select=$('#gridLoc').datagrid('getSelected');
	if(select == null){
		$.messager.alert('��ʾ','��ѡ��');
		return false;
	}
	var index=$('#gridLoc').datagrid('getRowIndex',select);
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ���ÿ�����',function(r){    
    	if (r){   
		$('#gridLoc').datagrid('deleteRow',index);
    	}  
	});
	
}
