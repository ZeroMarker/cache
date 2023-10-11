
batchsetting = function (year,schemdr) {
	var $win;
    $win = $('#batchsetting').window({
        title: '批量',
        width: 700,
        height: 300,
        top: ($(window).height() - 300) * 0.5,
        left: ($(window).width() - 700) * 0.5,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭窗口后触发
            $("#batchsetfm").form("reset")
            $("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');
	$("#CopyClose").unbind('click').click(function(){
        $win.window('close');
    });
     // 会计年度的文本框赋默认值 
	$("#Year2box").val(year);
	
	// 科目类别的下拉框
    var TypeCodeObj = $HUI.combobox("#TypeCode",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = 1;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        var value = $('#TypeCode').combobox('getValue');
	        $('#Code').combobox('clear'); //清除原来的数据
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemLevDisplay&hospid="+hospid+"&userdr="+userid+"&flag=0&year="+year+"&type="+value;
	        $('#Code').combobox('reload', url);//联动下拉列表重载  
        }
    });
     
	//上级科目combox
    var SuperCodeObj = $HUI.combobox("#Code",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemLevDisplay",
        mode:'remote',
        delay:200,
        valueField:'code',   
        textField:'codename',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid;
            param.userdr = userid;
            param.flag=0;
            param.year=year;
            param.type=$('#TypeCode').combobox('getValue')  
        },
        onSelect:function(data){
	    
	        $('#Code').combobox('clear'); //清除原来的数据+" "+data.code
	        $("#Code").combobox('setValue',data.name.replace(/&nbsp;/g, "")+" "+data.code);
	         
	          
        }
        
    })
     
     //计算方法的下拉框
	var CalMethObj =  $HUI.combobox("#CalMeth",{  
        valueField:'rowid',    
        textField:'name',
        data: [{
	                'rowid': 1,
                    'name': "公式计算"
                },{
	                'rowid': 2,
	                'name': "历史数据*比例系数"
	            },{
		            'rowid': 3,
		            'name': "历史数据" 
		        }]
     });
   /////////////////////////公式计算//////////////////////////// 
  var newvalue = $('#CalMeth').combobox('getText'); 
    $("#CalMeth").combobox({
    onChange:function(newvalue){
	     if(newvalue==1){
		     $("#Formula").attr("disabled",false);
	     } else{
             $("#Formula").attr("disabled",true);
		     }
    }
    
    });
	$("#CalMeth").combobox("disable");
    $("#Formula").attr("disabled",true);
    $("#CalNo").attr("disabled",true);

	/////////////////////////是否计算////////////////////////////
	$("#IsCalcul").checkbox({
        onCheckChange:function(event,value){
            if(!value){
                $("#CalMeth").combobox("disable");
                $("#CalMeth").combobox("clear");
                $("#Formula").attr("disabled",true);
                $("#CalNo").attr("disabled",true);
            }else{
                $("#CalMeth").combobox("enable");
                $("#CalNo").attr("disabled",false);
            }
        }
    })
    
    //////////////////////////公式描述////////////////////////////////
      $("#Formula").focus(function(){
	      var oldFormula=$('#Formula').val();
	      formformula()	
				})
    //////////////////////////保存、关闭///////////////////////////////
     
	$("#CopySave").unbind('click').click(function(){
        var year = $('#Year2box').val();
        var Itype = $('#TypeCode').combobox('getValue');
        var isSplit = $('#IsSplit').checkbox('getValue'); 
        var supcode = $('#Code').combobox('getValue').split(" ")[1]; 
        var isCal = $('#IsCalcul').checkbox('getValue');
        var formuladesc = $('#Formula').val();
        var CalNo = $('#CalNo').val();
        var formulacode = $('#FormulaCode').val();
        var calmethod = $('#CalMeth').combobox('getValue');
        
        if (typeof(supcode) == "undefined") {
	        var supercode = '';
	        } else {
		    var  supercode = $('#Code').combobox('getValue').split(" ")[1]; 
		    } 
		    
	   if (isSplit==true) {
			isSplit = 1
		} else {
		    isSplit = 0
		    }
		if (isCal==true) {
			isCal = 1
			} else {
			isCal = 0
			}
					
       var data = "";
		   data = schemdr + "|" + year
		    + "|" + Itype
		    + "|" + calmethod + "|" + isSplit
		    + "|" + "" + "|" + isCal
		    + "|" + formulacode
		    + "|" + formuladesc
		    + "|" + supercode + "|" + CalNo;
		  

         $.m({
            ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
            MethodName:'BatchInsert',
            data:data          
            },
            function(data){
                if(data==0){
	                $.messager.popover({
		                msg: '保存成功！',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
	                $('#DetailGrid').datagrid("reload");
	              
                }else{
	                $.messager.popover({
		                msg: data,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
                }
              }
            );
        $win.window('close');  
	});
	  $("#CopyClose").click(function(){
        $win.window('close');
    });
}	
	
											
