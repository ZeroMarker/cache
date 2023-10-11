 var hospid = session['LOGON.HOSPID'];
 
 //生成报表数据
  MakeData = function () {   
	var $win;
    $win = $('#Makewin').window({
        title: '生成报表数据',
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


//年度下拉框
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
     
//报表名称下拉框
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
//生成报表数据按钮
  $("#DataBtn").unbind('click').click(function() {
	 $.messager.confirm('确定','确定生成报表数据吗？',function(t){
	 if(t){
		 var Year   = $('#YearBox').combobox('getValue')
	     var Report   = $('#ReportNBox').combobox('getValue')
	     if(Year == ""){
		  $.messager.popover({
			  msg:'请选择年度！',
			  timeout: 2000,type:'alert',
			  showType: 'show',
			  style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					 top:1}}); 
			  return;}
         if(Report == ""){
	      $.messager.popover({
		      msg:'请选择报表名称！',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}}); 
		      return;}
			    $.messager.progress({
	                      title: '提示',
	                      msg: '正在生成，请稍候……'
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
					            msg: '保存成功！',
					            type:'success',
					            style:{"position":"absolute","z-index":"9999",
					            left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					            top:1}});
					            $.messager.progress('close');
					      }else{
						     $.messager.popover({
							     msg: '保存失败'+rtn,
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