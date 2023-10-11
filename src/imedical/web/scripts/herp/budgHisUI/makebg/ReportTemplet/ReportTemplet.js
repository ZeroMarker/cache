var hospid = session['LOGON.HOSPID'];

$(function(){//��ʼ��
    Initmain();
    $('#ReportCodeBox').val('')
    $('#ReportNameBox').val('')
}); 
 
function Initmain(){
	MainColumns=[[{
	     field:'ReportTempletID',
	     hidden: true
	     },{
	     field:'CompDR',
	     hidden: true
	     },{
	     field:'ReportCode',
	     title:'�������',
	     width:70,
	     allowBlank:false,
	     required:true,
	     align:'left',
	     halign:'left',
	     editor:{
		     type:'validatebox',
		     options:{
			     required:true}}
	     },{
		 field:'ReportName',
		 title:'��������',
		 width:150,
		 align:'left',
		 allowBlank:false,
		 required:true,
		 halign:'left',
		 editor:{
			 type:'validatebox',
			 options:{
			     required:true}}
		 },{
	     field:'ReportClass',
	     title:'�������',
	     width:70,
		 align:'center',
		 halign:'center',
		 formatter:comboboxFormatter,
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 data:[
				 {rowid:'1',name:'���ñ���'},
				 {rowid:'2',name:'�Զ���'}]
				 }}
	     },{
		 field:'ReortStatus',
         title:'����״̬',
         width:65,
		 align:'center',
		 halign:'center'
		 },{
	     field:'IsStop',
	     title:'�Ƿ�ͣ��',
	     width:65,
	     align:'center',
	     halign:'center',
	     editor:{type:'checkbox',options:{on:'1',off:'0'}},
	     formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    }
	     },{
		 field:'IsRepMonth',
		 title:'�±�',
		 width:40,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}  
                    },
         editor:{type:'checkbox',options:{on:'1',off:'0'}}
		 },{
		 field:'IsRepSeason',
		 title:'����',
		 width:40, 
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
		 },{
	     field:'IsRepHalf',
	     title:'���걨',
	     width:54,
	     align:'center',
	     halign:'center',
	     formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
	     },{
		 field:'IsRepYear',
		 title:'�걨',
		 width:40,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
		 },{
		 field:'ColGroupNo',
		 title:'��������',
	     width:70,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
		 },{
		 field:'startYearMonth',
		 title:' ��������',
		 width:90,
		 align:'center',
		 halign:'center'
		 },{
	     field:'StopYearMonth',
	     title:'ͣ������',
	     width:90,
	     align:'center',
	     halign:'center'
	     },{
	     field:'BudgReportTempletSID',
	     title:'ԭ����',
	     width:150,
	     align:'left',
	     halign:'left',
	     formatter:function(value,row,index){
			 return row.BudgReportTempletSName;
			},
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 mode:'remote',
				 url:$URL+"?ClassName=herp.budg.hisui.udata.uReportTemplet&MethodName=ListFundType",
				 delay:200,
				 onBeforeLoad:function(param){
					 var row=$('#MainGrid').datagrid('getSelected')
					 if(row.rowid==undefined){row.rowid=0}
			      param.str = param.q;
			      param.rowid=row.rowid
	                    	}}}
	     },{
	     field:'LinkFile',
	     title:'˵���ĵ�',
	     width:70,
	     align:'center',
	     halign:'center',
	     formatter:function(value,row,index){
		    return '<a href="#" class="SpecialClass"  title="����" data-options="iconCls:\'icon-attachment\'" onclick=attachment('+index+')></a>'}
	     },{
	     field:'Checker',
	     title:'�����',
	     width:100,
		 align:'left',
		 halign:'left'
	     },{
		 field:'CheckDate',
		 title:' ���ʱ��',
		 width:90,
		 align:'center',
		 halign:'center'
		 },{
		 field:'StopDesc',
		 title:'ͣ��ԭ��',
		 width:80,
		 align:'left',
		 halign:'left'
		 },{
	     field:'stoper',
	     title:'ͣ����',
	     width:80,
		 align:'left',
		 halign:'left'
	     },{
		 field:'stopDate',
		 title:'ͣ��ʱ��',
	     width:90,
		 align:'center',
		 halign:'center'
		 }]]
		 
		 
	var MaintableObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uReportTemplet",
            MethodName:"List",
            hospid: hospid
        },
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: true, 
        nowrap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onClickRow:onClickRow,
        toolbar: '#tb',
        onLoadSuccess:function(data){
            if(data){$('.SpecialClass').linkbutton({plain:true})}
            }
     });
     
    ///�е���¼�����    
        var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				$('#MainGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
        function onClickRow(index){
	        $('#MainGrid').datagrid('endEdit', editIndex);
	        var row = $('#MainGrid').datagrid('getSelected');
	        $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uReportTemplet",
                MethodName:"DetailList",
                ReportTempletID : row.rowid  
            });
	        if(row.ReortStatus=="���"){
	                  return;
	        }else{
			if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
					$('#MainGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex)}
			}}}
			
	 ///ɾ������
	 function deleteFn(rowid){
		 $.m({
			 ClassName:'herp.budg.hisui.udata.uReportTemplet',
             MethodName:'Delete',
             rowid : rowid
             },
             function(SQLCODE){
	             $.messager.progress({
                 title: '��ʾ',
                 msg: '����ɾ�������Ժ򡭡�'
                 });
                 if(SQLCODE==0){
	                 $.messager.popover({
		                 msg: 'ɾ���ɹ���',
		                 type:'success',
                  		 style:{"position":"absolute","z-index":"9999",
                  				left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                  				top:1}});
                  	 $.messager.progress('close');
                  	 $("#MainGrid").datagrid("reload");
                  	 $("#DetailGrid").datagrid("reload");
                 }else{
	                 $.messager.popover({
		                 msg: 'ɾ��ʧ�ܣ�'+SQLCODE,
		                 type:'error',
		                 style:{"position":"absolute","z-index":"9999",
		                 		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                 		top:1}})
		             $.messager.progress('close');
		             }
		      })
		 } 
  ///���溯��
  function saveFn(methodname,data){
	  $.m({
		  ClassName:'herp.budg.hisui.udata.uReportTemplet',
		  MethodName:methodname,
		  data:data
		  },
		  function(SQLCODE){
			  if(SQLCODE==0){
				  $.messager.popover({
					  msg: '����ɹ���',
					  type:'success',
					  style:{"position":"absolute","z-index":"9999",
					         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					         top:1}});
			      $.messager.progress('close');
			      $('#MainGrid').datagrid("reload");
			      editIndex = undefined;
			  }else{
				  $.messager.popover({
					  msg: '����ʧ��'+SQLCODE,
					  type:'error',
					  style:{"position":"absolute","z-index":"9999",
					         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					         top:1}
				   })
				  $.messager.progress('close'); 
		 }})}
  
  ///��ѯ����¼� 
  $("#MainFindBtn").click(function(){
	    var ReportCode   = $('#ReportCodeBox').val()
        var ReportName   = $('#ReportNameBox').val()
     
        MaintableObj.load({
                ClassName: "herp.budg.hisui.udata.uReportTemplet",
                MethodName: "List",
                ReportCode : ReportCode,
                ReportName : ReportName,
                hospid: hospid
            })});
          

///ɾ������¼�
  $("#DelBn").click(function() {
     var row = $('#MainGrid').datagrid('getSelected');
     if(row == null){
         $.messager.popover({
             msg:'��ѡ����Ҫɾ�����У�',
             timeout: 2000,type:'alert',
             showType: 'show',
             style:{"position":"absolute","z-index":"9999",
                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                      top:1}}); 
         return;
    }else if(row.ReortStatus=="���"){
         $.messager.popover({
               msg:'�˱�������ˣ�����ɾ����',
               timeout: 2000,type:'alert',
               showType: 'show',
               style:{"position":"absolute","z-index":"9999",
                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                      top:1}}); 
               return;
     }else{
         var rowDetail = $('#DetailGrid').datagrid('getRows').length;
         var rowid = row.rowid;
         if((rowDetail>0)&&(rowid>0)){
             $.messager.confirm('ȷ��','�˱�������ϸ��ȷ��ɾ����',function(t){
                 if(t){
                     deleteFn(rowid);
                    }
                })
        }else{
            $.messager.confirm('ȷ��','ȷ��ɾ����',function(t){
                if(t){
                    if(rowid>0){
                        deleteFn(rowid);
                    }else{
                        editIndex= $('#MainGrid').datagrid('getRows').length-1;
                        $('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
                    }
                }
                })}
           }})

//����һ�е���¼�
  $("#AddBn").click(function(){
	  if (endEditing()){
		  $('#MainGrid').datagrid('appendRow',{ReortStatus:"�½�"}); 
		  editIndex = $('#MainGrid').datagrid('getRows').length-1;
		  $('#MainGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}})

//�������¼�
  $("#SaveBn").click(function(){
	  var indexs = $('#MainGrid').datagrid('getEditingRowIndexs');
	  if (indexs.length > 0) {
		  for (i = 0; i < indexs.length; i++) {
			  var ed = $('#MainGrid').datagrid('getEditor', {
				  index: indexs[i],
				  field: 'BudgReportTempletSID'
				  });
			   if (ed) {
				   var BudgReportTempletSName = $(ed.target).combobox('getText');
				   $('#MainGrid').datagrid('getRows')[indexs[i]]['BudgReportTempletSName'] = BudgReportTempletSName;
						 }
	           $('#MainGrid').datagrid('endEdit', indexs[i]);
			     }}
	  
	 //alert(editIndex);
	     $.messager.confirm('ȷ��','ȷ��Ҫ����ѡ����������',function(t){
		     if(t){ 
		     var rows = $('#MainGrid').datagrid("getChanges");
		     if(rows.length==0){
			     $.messager.popover({
				     msg:'û����Ҫ����ļ�¼��',
				     timeout: 2000,type:'alert',
				     showType: 'show',
				     style:{"position":"absolute","z-index":"9999",
				           left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				           top:1}})
				           return;
			    }	  
		     if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i]; 
		              var rowid= row.rowid;
		              var ReportCode=((row.ReportCode==undefined)?'':row.ReportCode);
		              var ReportName=((row.ReportName==undefined)?'':row.ReportName);
		              var ReportClass=((row.ReportClass==undefined)?'':row.ReportClass);
		              var IsRepMonth=((row.IsRepMonth==undefined)?'':row.IsRepMonth);
		              var IsRepSeason=((row.IsRepSeason==undefined)?'':row.IsRepSeason);
		              var IsRepHalf=((row.IsRepHalf==undefined)?'':row.IsRepHalf);
		              var IsRepYear=((row.IsRepYear==undefined)?'':row.IsRepYear);
		              var ColGroupNo=((row.ColGroupNo==undefined)?'':row.ColGroupNo);
		              var startYearMonth=((row.startYearMonth==undefined)?'':row.startYearMonth);
		              var StopYearMonth=((row.StopYearMonth==undefined)?'':row.StopYearMonth);
		              var BudgReportTempletSID=((row.BudgReportTempletSID==undefined)?'':row.BudgReportTempletSID);
		              //alert(ReportCode);
		             if(!row.ReportCode){
			             $.messager.popover({
				             msg: '������벻��Ϊ��',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
					 if(!row.ReportName){
			             $.messager.popover({
				             msg: '�������Ʋ���Ϊ��',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
                     
		              $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  })
	                  if(!row.rowid){//����
	                        var data=hospid+"|"+ReportCode+"|"+ReportName+"|"+ReportClass
	                           +"|"+0+"|"+IsRepMonth+"|"+IsRepSeason
	                           +"|"+IsRepHalf+"|"+IsRepYear+"|"+ColGroupNo+"|"+BudgReportTempletSID;
	                        saveFn('Insert',data);
		               }else{//�������޸�
		                    var data2=hospid+"|"+ReportCode+"|"+ReportName+"|"+ReportClass
		                       +"|"+IsRepMonth+"|"+IsRepSeason
		              	       +"|"+IsRepHalf+"|"+IsRepYear+"|"+ColGroupNo+"|"+BudgReportTempletSID+"|"+rowid;
		              	    saveFn('Update',data2);		
						}
					 editIndex = undefined;
					 $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
	                 }
	          }else{
		          return;
		          }
	     }})
	  })

}