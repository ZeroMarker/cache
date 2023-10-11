var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
$(function(){//��ʼ��
    Init();
    $('#ReportCodeBox').val('')
    $('#ReportNameBox').val('')
}); 
 
function Init(){  
	MainColumns=[[{
	     field:'Manipulate',
	     title:'����',
	     width:140,
	     align:'center',
	     halign:'center',
	     formatter:function(value,row,index){
		    return '<a href="#" class="SpecialClass" title="���" data-options="iconCls:\'icon-stamp\'"  onclick=stamp('+index+') ></a>'
        + '<a href="#" class="SpecialClass" title="ȡ�����" data-options="iconCls:\'icon-stamp-cancel\'" onclick=stampcancel('+index+') ></a>'
        + '<a href="#"  class="SpecialClass" title="����" data-options="iconCls:\'icon-run\'" onclick=start('+index+')></a>'
        + '<a href="#"  class="SpecialClass" title="ͣ��" data-options="iconCls:\'icon-unuse\'" onclick=stop('+index+')></a>'}
	     },{
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
	     width:65,
		 align:'left',
		 halign:'left',
		 formatter:comboboxFormatter,
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 data:[
				 {rowid:'1',name:'���ñ���'},
				 {rowid:'2',name:'�Զ���'}],
				 }}
	     },{
		 field:'ReortStatus',
         title:'����״̬',
         width:65,
		 align:'center',
		 halign:'center',
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
                    },
	     },{
		 field:'IsRepMonth',
		 title:'�±�',
		 width:40,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
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
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
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
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
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
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
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
		 halign:'center',
		 },{
	     field:'StopYearMonth',
	     title:'ͣ������',
	     width:90,
	     align:'center',
	     halign:'center',
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
	     width:50,
		 align:'left',
		 halign:'left',
	     },{
		 field:'CheckDate',
		 title:' ���ʱ��',
		 width:90,
		 align:'center',
		 halign:'center',
		 },{
		 field:'StopDesc',
		 title:'ͣ��ԭ��',
		 width:80,
		 align:'left',
		 halign:'left',
		 },{
	     field:'stoper',
	     title:'ͣ����',
	     width:80,
		 align:'left',
		 halign:'left',
	     },{
		 field:'stopDate',
		 title:'ͣ��ʱ��',
	     width:90,
		 align:'center',
		 halign:'center',
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
        split:true,
        onClickRow:onClickRow,
        toolbar: '#tb',
        onLoadSuccess:function(data){
            if(data){
                $('.SpecialClass').linkbutton({
                    plain:true
                })
            }
        }
        });
            
    ///�е���¼�
    function onClickRow(index){
	    var row = $('#MainGrid').datagrid('getSelected');
            $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uReportTemplet",
                MethodName:"DetailList",
                ReportTempletID : row.rowid  
            }); 
	        }
	            
   ///��˹���
   stamp=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.ReortStatus=="���"){
		   $.messager.popover({
		        msg:'�ñ�����Ϊ���״̬��',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	        $.messager.confirm('ȷ��', '��˺󲻿��ٱ༭���Ƿ�ȷ����', function(t){
		        
		        if(t){
			        $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'stampornot',
			        	rowid : row.rowid,
			        	ReortStatus : 1,
			        	Checker:userid,
			        	CheckDate:""
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '��ʾ',
	                      msg: '������ˣ����Ժ򡭡�'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '��˳ɹ���',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: '���ʧ�ܣ�'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })
			        }})}
	   }    
 ///ȡ�����       
    stampcancel=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.ReortStatus=="�½�"){
		   $.messager.popover({
		        msg:'�ñ�������״̬������ȡ����',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	        $.messager.confirm('ȷ��', 'ȷ��ȡ�������', function(t){
		        if(t){
			        $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'stampornot',
			        	rowid : row.rowid,
			        	ReortStatus : 0,
			        	Checker:userid,
			        	CheckDate:""
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '��ʾ',
	                      msg: '������ˣ����Ժ򡭡�'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '��˳ɹ���',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: '���ʧ�ܣ�'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })	 
			        }})}
	   }    
            
///����           
    start=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.IsStop==0){
		   $.messager.popover({
		        msg:'�ñ��������ã�',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	        $.messager.confirm('ȷ��', 'ȷ��������', function(t){
		        if(t){
			        $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'start',
			        	rowid : row.rowid,
			        	isstop : 0,
			        	startYearMonth :""
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '��ʾ',
	                      msg: '�������ã����Ժ򡭡�'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '���óɹ���',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: '����ʧ�ܣ�'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })
			        }})}
	   }
	    
	   //ͣ��   
      stop=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.IsStop==1){
		   $.messager.popover({
		        msg:'�ñ�����ͣ�ã�',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	       Stopreason(row,userid);
        }}
        
     // ��ѯ 
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
}