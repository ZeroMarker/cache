// 编辑公式

formula = function (oldFormula,index,grid,field,field2) {
	
	// 用于显示
		formulaStr = "";
		// 表达式描述
		expreDesc = "";
		// 用于退格
		formulaStr2 = "";
		// 用于存储
		formulaStr3 = "";
		checkStr = "";
	var $win;
    $win = $('#formulawin').window({
        title: '规则定义',
        width: 900,
        height: 600,
        top: ($(window).height() - 600) * 0.5,
        left: ($(window).width() - 900) * 0.5,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭窗口后触发
            $("#formulafm").form("reset")
        }
    });
    $win.css('display','block');
    $win.window('open');
	$("#FormulaClose").unbind('click').click(function(){
        $win.window('close');
    });
    
    $("#FormulaField").val(oldFormula)
    
    function showValue(name, code) {
		formulaStr = formulaStr + code;
		if (formulaStr2 == "") {
			formulaStr2 = code;
		} else {
			formulaStr2 = formulaStr2 + code;
		}
		
		if (formulaStr3 == "") {
			formulaStr3 = name;
		} else {
			formulaStr3 = formulaStr3+ "#" + name;
		}
		
		$("#FormulaField").val(formulaStr)
	};
	
		
	 $('.widthbtn').unbind('click').click( function (e) {
    	//var fun = toolbar[e.target.textContent];
    	//if (fun) { fun(); }
    	//console.log(this.id);
    	//alert(e.target.textContent);
    	var btntext= e.target.textContent;
    	showValue(btntext,btntext);
    	checkStr = checkStr + '@' +  btntext + '@';
    	
	});
	
	$('#btnYearMounth').unbind('click').click( function (e) {
    	var btntext= "YearMonth";
    	var ruledesc = "预算年月"
    	showValue(btntext,ruledesc);
    	checkStr = checkStr + '@' +  btntext + '@';
	});
	
	$('#btnDate').unbind('click').click( function (e) {
    	var btntext= "Date";
    	var date="日期"
    	showValue(btntext,date);
    	checkStr = checkStr + '@' +  btntext + '@';
	});
	
	$('#btnNameFirst').unbind().click( function (e){
		
		var btntext="FName"
		var Fname="名称首字母"
		showValue(btntext,Fname);
		checkStr = checkStr + '@' +  btntext + '@';
		
		});
	
	$('#btnTow').unbind('click').click( function (e){
		
		var btntext= "0X"
		var number1 = "2位数" 
		showValue(btntext,number1)
		checkStr = checkStr + '@' + btntext + '@';
		 $('#btnAndThree').linkbutton("disable");
		});
		
	$('#btnThree').unbind('click').click( function (e) {
		var btntext= "00X"
		var number3= "3位数"
		showValue(btntext,number3)
		checkStr = checkStr + '@' + btntext + '@'
		$('#btnAndThree').linkbutton("enable");
		});
		
	$('#btnFour').unbind('click').click( function (e) {
		
		var btntext= "0X0X"
		var number4= "4位数"
		showValue(btntext,number4)
		checkStr = checkStr + '@' + btntext + '@'
		
		});
		
	$('#btnFive').unbind('click').click( function(e){
		
		var btntext= '00X0X'
		var number5= "5位数"
		showValue(btntext,number5)
		checkStr = checkStr + '@' + btntext + '@'
		});
		
	$('#btnSix').unbind('click').click( function (e) {
		var btntext= '0X0X0X'
		var number6= "6位数"
		showValue(btntext,number6)
		checkStr = checkStr + '@' + btntext + '@'
		});
		
	$('#btnAnd').unbind('click').click( function(e){
		
		var btntext= '+1'
		var andone="递增"
		showValue(btntext,andone)
		checkStr = checkStr + '@' + btntext + '@'
		
		});
		
	$('#btnAndTow').unbind('click').click( function(e){
		
		var btntext= '+2'
		var andtwo="以2为单位递增"
		showValue(btntext,andtwo)
		checkStr = checkStr + '@' + btntext + '@'
		
		});
		
	$('#btnAndThree').unbind('click').click( function(e){
		
		var btntext= '+3'
		var andthree="以3为单位递增"
		showValue(btntext,andthree)
		checkStr = checkStr + '@' + btntext + '@'
		
		});
	
	
	
	$('#btnC').unbind('click').click( function (e) {
    	formulaStr = "";
		formulaStr2 = "";
		formulaStr3="";
		checkStr = "";
		$("#FormulaField").val(formulaStr)
		$('#btnAndThree').linkbutton("enable");
    	
	})
	$('#btnCE').unbind('click').click( function (e) {
		//if(formulaStr3 = "2位数" ){
			//$('#btnAndThree').linkbutton("enable")
			//}
		formulaStr2 = formulaStr2.substring(0,formulaStr2.length-1);
		formulaStr3 = formulaStr3.substring(0,formulaStr3.lastIndexOf('#'));
		//console.log(formulaStr2);
		formulaStr = formulaStr2.replace(/\;/g, '');
		checkStr = checkStr.substring(0,checkStr.lastIndexOf('@'));
		$("#FormulaField").val(formulaStr)
	});
									
    //////////////////////////保存、关闭///////////////////////////////
     
	$("#FormulaSave").unbind('click').click(function(){
        //formulaTrgg.setValue(globalStr);
		//formulaTrgg2.setValue(globalStr2);
		
		//公式描述
        var ed1 = grid.datagrid("getEditor",{index:index,field:field});
        $(ed1.target).val(formulaStr3);
        $('#MainGrid').datagrid('endEdit', index);
        
        //公式存储
        $('#MainGrid').datagrid('editCell',{index:index,field:field2});
        var ed2 = grid.datagrid("getEditor",{index:index,field:field2});
        $(ed2.target).val(formulaStr);
       
        $('#MainGrid').datagrid('endEdit', index);
        
        $("#formulafm").form("reset")
        $win.window('close');  
	});
	  $("#FormulaClose").click(function(){
		  $('#MainGrid').datagrid('endEdit', index);
		  $("#formulafm").form("reset")
        	$win.window('close');
    });
}	
	
											
									
