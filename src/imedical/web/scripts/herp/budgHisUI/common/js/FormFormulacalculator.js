// �༭��ʽ
//$('#FormulaCode') ��ʽ�����ı���
//$('#Formula') ��ʽ�����ı���
formformula = function () {	
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
        title: '��ʽ����',
        width: 700,
        height: 500,
        top: ($(window).height() - 500) * 0.5,
        left: ($(window).width() - 700) * 0.5,
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
    $("#fItembox").combobox('setValue',"");
    
    
    //Ԥ�����combox
    var fYearboxObj = $HUI.combobox("#fYearbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect:function(data){
	       
	        $('#fItembox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&hospid="+hospid+"&userdr="+userid+"&year="+data.year+"&type="+$('#fItemTypebox').combobox('getValue');
	        $('#fItembox').combobox('reload', url);//���������б�����  
        }
    });
    //��Ŀ����
    var fItemTypeboxObj = $HUI.combobox("#fItemTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:function(data){
	        $('#fItembox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&hospid="+hospid+"&userdr="+userid+"&year="+$('#fYearbox').combobox('getValue')+"&type="+data.code;
	        $('#fItembox').combobox('reload', url);//���������б�����  
	        
     	}
    }); 
    //Ԥ����Ŀ
    var fItemboxObj = $HUI.combobox("#fItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid=hospid;
            param.userdr=userid;
            param.year=$('#fYearbox').combobox('getValue');
            param.type=$('#fItemTypebox').combobox('getValue');
        },
        onSelect:function(data){
	        $('#fEconomicItembox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemEco&hospid="+hospid+"&userdr="+userid+"&year="+$('#fYearbox').combobox('getValue')+"&itemcode="+data.code;
	        $('#fEconomicItembox').combobox('reload', url);//���������б�����
	        
	        showValue(data.name, '#$IT' + data.code);
			$("#fItembox").combobox('setValue',"");
			// alert(rec.get('rowid'));
			checkStr = checkStr + '@' +  data.code + '@';
	        
     	}
    });
    
    //���ÿ�Ŀ
    var fEconomicItemObj = $HUI.combobox("#fEconomicItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemEco",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid=hospid;
            param.userdr=userid;
            param.year=$('#fYearbox').combobox('getValue');
            param.itemcode=$('#fItembox').combobox('getValue');
        },
        onSelect:function(data){
	        showValue(data.name, '#$EI' + data.code);
			$("#fEconomicItembox").combobox('setValue',"");
			// alert(rec.get('rowid'));
			checkStr = checkStr + '@' +  data.code + '@';
	        
     	}
    });
    //�������
    var fDeptTpyeObj = $HUI.combobox("#fDeptTpyebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid=hospid;
            param.userdr=userid;
            param.str = param.q;
        },
        onSelect:function(data){
	        $('#fDeptbox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&hospid="+hospid+"&userdr="+userid+"&flag = 1^"+data.rowid;
	        $('#fDeptbox').combobox('reload', url);//���������б�����
	        
	        showValue(data.name, '#$TD' + data.rowid);
			$("#fDeptTpyebox").combobox('setValue',"");
			checkStr = checkStr + '@' +  data.rowid + '@';
     	}
    });
    //Ԥ�����
    var fDeptObj = $HUI.combobox("#fDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag = 1+"^"+$('#fDeptTpyebox').combobox('getValue');
            param.str = param.q;
            param.hospid=hospid;
            param.userdr=userid;
        },
        onSelect:function(data){
	        showValue(data.name, '#$DT' + data.rowid);
			$("#fDeptbox").combobox('setValue',"");
			checkStr = checkStr + '@' +  data.rowid + '@';
	        
     	}
    });
    //����ģ��
    var fReportTempletObj = $HUI.combobox("#fReportTempletbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ReportTemplet",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid=hospid;
            param.str = param.q;
        },
        onSelect:function(data){
	        $('#fReportTempletDetailbox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ReportTempletIDetail&TempletID="+data.rowid;
	        $('#fReportTempletDetailbox').combobox('reload', url);//���������б�����
     	}
    });
    //������ϸ
    var fReportTempletDetailObj = $HUI.combobox("#fReportTempletDetailbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ReportTempletIDetail",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.TempletID = $('#fReportTempletbox').combobox('getValue');
            param.str = param.q;
        },
        onSelect:function(data){
	        showValue(data.name, '#$RT' + data.code+"_"+$('#fReportTempletbox').combobox('getValue'));
			$("#fReportTempletDetailbox").combobox('setValue',"");
			checkStr = checkStr + '@' +  data.code + '@';
	        
     	}
    });
    function showValue(name, code) {
		formulaStr = formulaStr + name;
		if (formulaStr2 == "") {
			formulaStr2 = name;
		} else {
			formulaStr2 = formulaStr2 +";"+ name;
		}
		
		if (formulaStr3 == "") {
			formulaStr3 = code;
		} else {
			formulaStr3 = formulaStr3 + code;
		}
		
		$("#FormulaField").val(formulaStr)
	};
	
		
	 $('.widthbtn').unbind('click').click( function (e) {
    	//var fun = toolbar[e.target.textContent];
    	//if (fun) { fun(); }
    	//console.log(this.id);
    	//alert(e.target.textContent);
    	var btntext= e.target.textContent;
    	showValue(btntext, "#"+btntext);
    	checkStr = checkStr + '@' +  btntext + '@';
    	
	});
	$('#btnC').unbind('click').click( function (e) {
    	formulaStr = "";
		formulaStr2 = "";
		formulaStr3="";
		checkStr = "";
		$("#FormulaField").val(formulaStr)
    	
	});
	$('#btnCE').unbind('click').click( function (e) {
		//console.log(formulaStr2);
		//console.log(formulaStr2.lastIndexOf(';'));
		formulaStr2 = formulaStr2.substring(0,formulaStr2.lastIndexOf(';'));
		formulaStr3 = formulaStr3.substring(0,formulaStr3.lastIndexOf('#'));
		//console.log(formulaStr2);
		formulaStr = formulaStr2.replace(/\;/g, '');
		checkStr = checkStr.substring(0,checkStr.lastIndexOf('@'));;
		$("#FormulaField").val(formulaStr)
	});
									
    //////////////////////////���桢�ر�///////////////////////////////
     
	$("#FormulaSave").unbind('click').click(function(){
        //formulaTrgg.setValue(globalStr);
		//formulaTrgg2.setValue(globalStr2);
		//��ʽ����
        $('#Formula').val(formulaStr);
        //��ʽ�洢
        $('#FormulaCode').val(formulaStr3);
               
        $("#formulafm").form("reset")
        $win.window('close');  
	});
	  $("#FormulaClose").click(function(){
		  $("#formulafm").form("reset")
        	$win.window('close');
    });
}	
	
											
									
