// �༭��ʽ

formula = function (oldFormula,index,grid,field,field2) {
	
	// ������ʾ
		formulaStr = "";
		// ���ʽ����
		expreDesc = "";
		// �����˸�
		formulaStr2 = "";
		// ���ڴ洢
		formulaStr3 = "";
		checkStr = "";
	var $win;
    $win = $('#formulawin').window({
        title: '������',
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
        onClose:function(){ //�رմ��ں󴥷�
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
    	var ruledesc = "Ԥ������"
    	showValue(btntext,ruledesc);
    	checkStr = checkStr + '@' +  btntext + '@';
	});
	
	$('#btnDate').unbind('click').click( function (e) {
    	var btntext= "Date";
    	var date="����"
    	showValue(btntext,date);
    	checkStr = checkStr + '@' +  btntext + '@';
	});
	
	$('#btnNameFirst').unbind().click( function (e){
		
		var btntext="FName"
		var Fname="��������ĸ"
		showValue(btntext,Fname);
		checkStr = checkStr + '@' +  btntext + '@';
		
		});
	
	$('#btnTow').unbind('click').click( function (e){
		
		var btntext= "0X"
		var number1 = "2λ��" 
		showValue(btntext,number1)
		checkStr = checkStr + '@' + btntext + '@';
		 $('#btnAndThree').linkbutton("disable");
		});
		
	$('#btnThree').unbind('click').click( function (e) {
		var btntext= "00X"
		var number3= "3λ��"
		showValue(btntext,number3)
		checkStr = checkStr + '@' + btntext + '@'
		$('#btnAndThree').linkbutton("enable");
		});
		
	$('#btnFour').unbind('click').click( function (e) {
		
		var btntext= "0X0X"
		var number4= "4λ��"
		showValue(btntext,number4)
		checkStr = checkStr + '@' + btntext + '@'
		
		});
		
	$('#btnFive').unbind('click').click( function(e){
		
		var btntext= '00X0X'
		var number5= "5λ��"
		showValue(btntext,number5)
		checkStr = checkStr + '@' + btntext + '@'
		});
		
	$('#btnSix').unbind('click').click( function (e) {
		var btntext= '0X0X0X'
		var number6= "6λ��"
		showValue(btntext,number6)
		checkStr = checkStr + '@' + btntext + '@'
		});
		
	$('#btnAnd').unbind('click').click( function(e){
		
		var btntext= '+1'
		var andone="����"
		showValue(btntext,andone)
		checkStr = checkStr + '@' + btntext + '@'
		
		});
		
	$('#btnAndTow').unbind('click').click( function(e){
		
		var btntext= '+2'
		var andtwo="��2Ϊ��λ����"
		showValue(btntext,andtwo)
		checkStr = checkStr + '@' + btntext + '@'
		
		});
		
	$('#btnAndThree').unbind('click').click( function(e){
		
		var btntext= '+3'
		var andthree="��3Ϊ��λ����"
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
		//if(formulaStr3 = "2λ��" ){
			//$('#btnAndThree').linkbutton("enable")
			//}
		formulaStr2 = formulaStr2.substring(0,formulaStr2.length-1);
		formulaStr3 = formulaStr3.substring(0,formulaStr3.lastIndexOf('#'));
		//console.log(formulaStr2);
		formulaStr = formulaStr2.replace(/\;/g, '');
		checkStr = checkStr.substring(0,checkStr.lastIndexOf('@'));
		$("#FormulaField").val(formulaStr)
	});
									
    //////////////////////////���桢�ر�///////////////////////////////
     
	$("#FormulaSave").unbind('click').click(function(){
        //formulaTrgg.setValue(globalStr);
		//formulaTrgg2.setValue(globalStr2);
		
		//��ʽ����
        var ed1 = grid.datagrid("getEditor",{index:index,field:field});
        $(ed1.target).val(formulaStr3);
        $('#MainGrid').datagrid('endEdit', index);
        
        //��ʽ�洢
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
	
											
									
