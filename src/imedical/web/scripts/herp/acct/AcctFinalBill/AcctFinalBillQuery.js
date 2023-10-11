 //=================================连接报表Query==========================//
  
	function Query(){
		var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
	    var tempId = acctTemplet.getValue();
		

		//加入校验
		if(period==""){
			Ext.Msg.show({title:'错误',msg:'会计期间不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			
		}else if(tempId==""){
			Ext.Msg.show({title:'错误',msg:'收支结转模板不能为空',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
		    //===============================显示报表=============================//
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//获取报表路径
			//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
			p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.InOutPayment.raq&period='+period+
						'&tempId='+tempId;
			
			reportFrame.src=p_URL;
		}
	}