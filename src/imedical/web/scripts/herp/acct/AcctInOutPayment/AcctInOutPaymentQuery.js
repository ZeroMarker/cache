 //=================================连接报表Query==========================//
  
	function Query(){
		//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
		var period = periodDate.getValue();
	    var tempId = acctTemplet.getValue();
				
		if(userid==""){
		
			AddAcctBook();
		}else{

		//加入校验
			if(tempId==""){
				Ext.Msg.show({title:'错误',msg:'收支结转模板不能为空 ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else{
				//===============================显示报表=============================//
				var reportFrame=document.getElementById("frameReport");
				var p_URL="";
				//获取报表路径
				//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
				p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.InOutPayment.raq&period='+period+
							'&tempId='+tempId+'&userid='+userid;
				
				reportFrame.src=p_URL;
			}
		}
	}
	//==================================期末收支预结转明细===========================================//
	function QueryTemp(){
		//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
		var period = periodDate.getValue();
	    var tempId = acctTemplet.getValue();
		var reportFrame=document.getElementById("frameReport");
		var p_URL="";
		//获取报表路径
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.InOutPaymentTemp.raq&period='+period+
					'&tempId='+tempId+'&userid='+userid;
		
		reportFrame.src=p_URL;
		
	}