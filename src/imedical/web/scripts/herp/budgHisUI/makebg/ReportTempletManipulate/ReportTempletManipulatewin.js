Stopreason = function (row,stoper) {    
	var $win;
    $win = $('#Reasonwin').window({
        title: 'ͣ��ԭ��',
        width: 500,
        height: 260,
        shadow: true,
        modal: true,
        closed: true,
        top: ($(window).height() - 300) * 0.5,
        left: ($(window).width() - 500) * 0.5,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onBeforeOpen:function(){
	       $("#ReasonField").val('')},
	    onClose:function(){ //�رմ��ں󴥷�
	       $("#ReasonField").val('');
           $("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
        }
        
    });
    $('#Reasonwin').css('display','block');
    $win.window('open');
    
	$("#SRClose").unbind('click').click(function(){
        $win.window('close');
    })
    $("#SRSave").unbind('click').click(function(){
	    var StopDesc=$('#ReasonField').val()
	    $.messager.confirm('ȷ��', 'ȷ��ͣ����', function(t){
		        if(t){
			        $win.window('close');
			        $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'stop',
			        	rowid : row.rowid,
			        	isstop : 1,
			        	stoper : stoper,
			        	StopDesc : StopDesc
					          },
					          
				function(SQLCODE){
					$.messager.progress({
	                      title: '��ʾ',
	                      msg: '����ͣ�ã����Ժ򡭡�'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: 'ͣ�óɹ���',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: 'ͣ��ʧ�ܣ�'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })
			        }})
	    
	    })
    
    }