
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
var UserGrpDr=session['LOGON.GROUPID'] ;
//保存其它规则
$(function(){

	initPhaLoc();
    
    $('#btnOk').bind("click",Save);  //点击查询

});

//初始化药房科室
function initPhaLoc()
{
	
	$('#combphaloc').combobox({  
		width:225,
		panelWidth: 225,
		url:url+'?action=GetStockPhlocDs&GrpDr='+UserGrpDr,  
		valueField:'rowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#combphaloc').combobox('getData');
            if (data.length > 0) {
                  $('#combphaloc').combobox('select', data[0].rowId);
				  initData(data[0].rowId);
              }

            
	    },
        onSelect: function(rec){
			initData(rec.rowId);

		}
		});
		
}
//保存
function Save()
{
	var phlocdr=$('#combphaloc').combobox('getValue'); //药房
	var bigflag="N";  //大剂量
	//var arrChk=$("input[name='chkBigPriBox'][checked]");
	//$(arrChk).each(function(){
    //   bigflag=this.value;
	//}); 
	$("input[type=checkbox][name=chkBigPriBox]").each(function(){
		if($('#'+this.id).is(':checked')){
			bigflag=this.value;
		}
	})
	var conflag="N";  //持续量
	//var arrChk=$("input[name='chkConFlagBox'][checked]");
	//$(arrChk).each(function(){
    //   conflag=this.value;
	//});
	$("input[type=checkbox][name=chkConFlagBox]").each(function(){
		if($('#'+this.id).is(':checked')){
			conflag=this.value;
		}
	})
	var Input=phlocdr+"^"+bigflag+"^"+conflag;

    $.ajax({
   	   type: "POST",
       url: url,
       data: "action=SaveOthRule&Input="+Input,
		//dataType: "json",
	   success: function(val){
          $.messager.alert('提示','保存成功');
	   },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });
    
}

//加载信息
function initData(phlocdr)
{
	   $("[name='chkBigPriBox']").prop("checked", false);
       $('#chkConFlag').attr("checked",false);
	   $.ajax({
		   type: "POST",
		   url: url,
	       data: {action:'GetOthRuleInfo',Input:phlocdr},
		   success: function(jsonString){
			    var obj = jQuery.parseJSON(jsonString);
				var BigPri=obj.bigflag;
				var ConFlag=obj.conflag;
				if (BigPri=="Y")
				{
					$("[name='chkBigPriBox']").attr("checked",'true');
					
				}
				//
	            if (ConFlag=="Y")
				{
					$('#chkConFlag').attr("checked",'true');
				}
	         }

	})


}