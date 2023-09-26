function InitDetailScreenEvent(obj) {
	var miniPMHandle=ExtTool.StaticServerObject("DHCPM.Handle.PMHandle");
	//var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(){
		obj.btnSave.on("click", obj.btnSave_click, obj);
	}
	var result=miniPMHandle.buttonVisible();
	//alert(result)
	if (result==0)
	{
		obj.btnSave.hidden=true;
	}
	obj.btnSave_click=function()
	{
		//alert(1)
		//alert(obj.DemandID.getValue());
		var DemandID=obj.DemandID.getValue()
		var EditDemDesc=obj.winfEditDemDesc.getValue();
		var winfDemDesc=obj.winfDemDesc.getValue();
		var userId=session['LOGON.USERID'];
		var str=DemandID+"^"+EditDemDesc+"^"+userId;
		//alert(str)
		if (EditDemDesc=="")
		{
			Ext.MessageBox.alert('Status', "修改内容不能为空！");
			return false;
		}
		var ret=miniPMHandle.editDemDesc(str,winfDemDesc);
		if (ret==0){Ext.MessageBox.alert('Status', "修改成功");
		obj.winfDemDesc.setValue(EditDemDesc);
		obj.winfEditDemDesc.setValue(winfDemDesc);
		}
		else {Ext.MessageBox.alert('Status', "修改失败:  "+ret);}
	
	}
		
			
			
			 obj.winflistPanel.on('cellclick', function (grid, rowIndex, columnIndex, e) { 
	

					var rec = e.getTarget('.PMCheckNote'); 	
					var record = obj.winflistPanel.getStore().getAt(rowIndex);  
	
					var RecRowid=record.get("RecRowid");
					//alert(RecRowid);
					var ComDate=record.get("ComDate");
					var ComTime=record.get("ComTime");
					var Location=record.get("Location");
					var HosStr=record.get("HosStr");
					var DHCCStr=record.get("DHCCStr");
					var OtherStr=record.get("OtherStr");
					var COmMethod=record.get("COmMethod");
					var ComDuration=record.get("ComDuration");
					var COmContent=record.get("COmContent");
					//var InHanderName=record.get("InHanderName");
					//alert(1)
					//alert(ComDuration)
					if (rec) 
					{ 
						var t = e.getTarget(); 
						var control = t.className; 
						//alert(control)
						if('PMWatch'==control)
						{
							objminiCom= new ComMiniScreen();
						objminiCom.miniComDate.setValue(ComDate);
						objminiCom.miniComDate.disabled=true;
						objminiCom.miniComTime.setValue(ComTime);
						objminiCom.miniComTime.disabled=true;
						objminiCom.miniComDuration.setValue(ComDuration);
						objminiCom.miniComDuration.disabled=true;
						objminiCom.miniComWay.setValue(COmMethod);
						objminiCom.miniComWay.disabled=true;
						objminiCom.miniHosStr.setValue(HosStr);
						objminiCom.miniHosStr.disabled=true;
						objminiCom.txtminiPrjStr.setValue(DHCCStr);
						objminiCom.txtminiPrjStr.disabled=true;
						objminiCom.txtminiOtherStr.setValue(OtherStr);
						objminiCom.txtminiOtherStr.disabled=true;
						objminiCom.miniLocation.setValue(Location); //
						objminiCom.miniLocation.disabled=true;
						objminiCom.txtminiComNote.setValue(COmContent);
						objminiCom.txtminiComNote.disabled=true;
						//objminiCom.winfInHandler.setValue(InHanderName);
						
						objminiCom.winminiScreen.show();
							
							
						}
						if('PMlookat'==control)
						{
							alert(1)
						}
						
						//var miniPMHandle=ExtTool.StaticServerObject("DHCPM.Handle.PMHandle");
						 //var Result = miniPMHandle.getRecValByID(RecRowid);
						//var RecArray=Result.split(' ');
						/* if (RecArray.length>0)
						{
							objminiCom.miniComDate.setValue(RecArray);
							
							
						} */
						 
						
						
						
					}
			},  
this); 



		obj.winfGPanel.on('cellclick', function (grid, rowIndex, columnIndex, e) { 
	

					var rec = e.getTarget('.PMCheckNote'); 	
					var record = obj.winfGPanel.getStore().getAt(rowIndex);  
	
					/* var RecRowid=record.get("RecRowid");
					//alert(RecRowid);
					var ComDate=record.get("ComDate");
					var ComTime=record.get("ComTime");
					var Location=record.get("Location");
					var HosStr=record.get("HosStr");
					var DHCCStr=record.get("DHCCStr");
					var OtherStr=record.get("OtherStr");
					var COmMethod=record.get("COmMethod");
					var ComDuration=record.get("ComDuration"); */
					var note=record.get("note");
					//alert(note)
					if (rec) 
					{ 
						var t = e.getTarget(); 
						var control = t.className; 
						//alert(control)
						if('PMlookat'==control)
						{
							objminiNote= new MiniNoteScreen();
							objminiNote.txtminiNote.setValue(note);
						    objminiNote.miniNotScreen.show();
							
							
						}
					
						
						//var miniPMHandle=ExtTool.StaticServerObject("DHCPM.Handle.PMHandle");
						 //var Result = miniPMHandle.getRecValByID(RecRowid);
						//var RecArray=Result.split(' ');
						/* if (RecArray.length>0)
						{
							objminiCom.miniComDate.setValue(RecArray);
							
							
						} */
						 
						
						
						
					}
			},  
	this); 
			
	};
	
	
	function ComMiniScreenEvent(obj) {
	
	
	obj.LoadEvent = function(args){
	}
	
	
}
	

			

