 var hospid = session['LOGON.HOSPID'];
 
 //���ɱ�������
  MakeData = function () {   
	var $win;
    $win = $('#Makewin').window({
        title: '���ɱ�������',
        width: 470,
        height: 230,
        top: ($(window).height() - 230) * 0.5,
	    left: ($(window).width() - 470) * 0.5,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onBeforeOpen:function(){
	       $("#YearBox").combobox('setValue',"");
	       $("#ReportNBox").combobox('setValue',"")},
    });
        $win.window('open');
        $("#Close").unbind('click').click(function(){
        $win.window('close');
    })


//���������
   var YearObj = $HUI.combobox("#YearBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = ""
            
        }
     })
     
//��������������
   var ReportNameObj = $HUI.combobox("#ReportNBox",{
	   valueField:'rowid',
	   textField:'name',
	   mode:'remote',
	   url:$URL+"?ClassName=herp.budg.hisui.udata.uReportTemplet&MethodName=ListFundType",
	   delay:200,
	   /*formatter:function(value,row,index){
				return row.BudgReportTempletSName;
			},*/
	   onBeforeLoad:function(param){
		   var row = $('#MainGrid').datagrid('getSelected');
		   if(row!=null){
			  $('#ReportNBox').combobox('setValue',row.rowid); 
			  param.str = param.q;
			  param.rowid=0
		    }else{
			  param.str = param.q;
			  param.rowid=0
			    }}
	   
     })
//���ɱ������ݰ�ť
  $("#DataBtn").unbind('click').click(function() {
	 $.messager.confirm('ȷ��','ȷ�����ɱ���������',function(t){
	 if(t){
		 var Year   = $('#YearBox').combobox('getValue')
	     var Report   = $('#ReportNBox').combobox('getValue')
	     if(Year == ""){
		  $.messager.popover({
			  msg:'��ѡ����ȣ�',
			  timeout: 2000,type:'alert',
			  showType: 'show',
			  style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					 top:1}}); 
			  return;}
         if(Report == ""){
	      $.messager.popover({
		      msg:'��ѡ�񱨱����ƣ�',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}}); 
		      return;}
			    $.messager.progress({
	                      title: '��ʾ',
	                      msg: '�������ɣ����Ժ򡭡�'
	                  }) 
	            $.m({
		            ClassName:'herp.budg.hisui.udata.uReportDataLedger',
		            MethodName:'GenTemplateData',
		            Hospid:hospid,
		            Year:Year,
		            TemplateID:Report
		            },
		            function(rtn){
			            if(rtn==0){
				            $.messager.popover({
					            msg: '����ɹ���',
					            type:'success',
					            style:{"position":"absolute","z-index":"9999",
					            left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					            top:1}});
					            $.messager.progress('close');
					      }else{
						     $.messager.popover({
							     msg: '����ʧ��'+rtn,
							     type:'error',
							     style:{"position":"absolute","z-index":"9999",
							     left:-document.body.scrollTop - document.documentElement.scrollTop/2,
							     top:1}
							     })
							  $.messager.progress('close'); 
							  }})              
			     }})
  })

    
    
    }