function InitViewScreenEvent(obj)
{
	var _DHCICUBedEquip=ExtTool.StaticServerObject('web.DHCICUBedEquip');
	var _DHCICUArrange=ExtTool.StaticServerObject('web.DHCICUArrange');
	var _DHCClinicCom=ExtTool.StaticServerObject('web.DHCClinicCom');
	
	obj.LoadEvent = function(args)
	{
	
	};
	
    obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc){
		    //var icuaId=rc.get("icuaId");
		    var bedrowid=rc.get("icuBedId");
            obj.retGridPanelequipStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCICUBedEquip';
		    param.QueryName = 'FindexeBed';
		    param.Arg1 = bedrowid;
		    param.ArgCnt = 1;
	        });
	       obj.retGridPanelequipStore.load({});
	    }
	    obj.btnstartstop.setText(" ");	    
    }
    obj.btnfindlist_click=function()
    {
	    var patName=obj.patname.getValue();
		var argWardType="In"
		var wardTypeRadio =Ext.getCmp('chkWardType').items;
		for(var i = 0; i < wardTypeRadio.length; i++){
			if(wardTypeRadio.get(i).checked){
				 if(wardTypeRadio.get(i).inputValue == "1"){
					 argWardType ="Into"
					 break;
				 }
				 if(wardTypeRadio.get(i).inputValue == "3"){
					 argWardType ="Out"
					 break;
				 }
				 if(wardTypeRadio.get(i).inputValue == "2"){
					 argWardType ="In"
					 break;
				 }
			 }
		}
		var regNo=obj.listregno.getValue();
		var regNo=_DHCClinicCom.GetPatCoverRegNo(regNo);
		
	    obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCICUArrange';
			//param.QueryName = 'FindICUArrange';
			param.QueryName = 'FindICUArrangeNew';
			param.Arg1 = obj.startdate.getRawValue();
			param.Arg2 = obj.enddate.getRawValue();
			param.Arg3 = regNo;
			param.Arg4 = session['LOGON.CTLOCID'];
			param.Arg5 = obj.liststatus.getValue();
			param.Arg6 = obj.listmedno.getValue();
			param.Arg7 = patName;
			param.Arg8 = argWardType;
			param.ArgCnt = 8;
		});
	obj.retGridPanelStore.load({});
	    obj.retGridPanelStore.load({});
	    obj.Bedid.setValue("");
	    //obj.startdate.setValue(new Date());
	    //obj.enddate.setValue(new Date());
	    obj.patname.setValue("");
	    obj.liststatus.setValue("");
	    obj.listregno.setValue("");
	    obj.listmedno.setValue("")
    }    
    obj.btnmonitor_click=function()
    {
	    bedId="";
	    var selectobj = obj.retGridPanel.getSelectionModel().getSelected();
	    if(selectobj)
	    {
		    var status=selectobj.get("tStatus");
		    if ((status!="R")&&(status!="M")&&(status!="T")&&(status!="F")) {
			alert("Setlect record please!");
			return;
		    }
			var icuaId=selectobj.get('icuaId');
			var EpisodeID=selectobj.get('tEpisodeID');
			if ((icuaId=="")&&(EpisodeID=="")) return;
			var curLocation=unescape(window.location);
	        curLocation=curLocation.toLowerCase();
	        var filePath=curLocation.substr(0,curLocation.indexOf('/csp/'))+"/service/DHCClinic/";
            //alert(icuaId+"^"+EpisodeID+"^"+filePath+"^"+bedId)
	        var lnk="dhcicurecord.csp?icuaId="+icuaId+"&EpisodeID="+EpisodeID+"&filePath="+filePath+"&bedId="+bedId;
	       //if (session['LOGON.USERID']='4359') //alert(lnk); //return;
		
	        window.open(lnk,"DHC重症信息系统","height=900,width=1440,toolbar=no,menubar=no,resizable=yes");
	        //showModalDialog(lnk,"DHCIcua","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
	    }
	    else
	    {
		    alert("请选择一条手术记录!")
	    }
    }  
    obj.retGridPanel_afteredit=function(ev)
    {
	    var icuaid=ev.record.data.icuaId;
	    if(ev.field=="tPatHeight")
	    {
		    var PatHeight=ev.value;
			if(ev.value!="")
			{
                var ret=_DHCICUArrange.InsertHeight(PatHeight,icuaid);
			}
			if(ret!=0) 
			{
				alert(ret);
				obj.retGridPanelStore.reload();
			}

	    }

	    if(ev.field=="tPatWeight")
	    {
		    var PatWeight=ev.value;
			if(ev.value!="")
			{
                var ret=_DHCICUArrange.InsertWeight(PatWeight,icuaid);
			}
			if(ret!=0) 
			{
				alert(ret);
				obj.retGridPanelStore.reload();
			}

	    }	    
    }  	
	obj.retGridPanelequip_rowclick = function()
	{
	    var rc = obj.retGridPanelequip.getSelectionModel().getSelected();
	    if (rc){ 
	    var stat=rc.get("TStat");
	    if (stat == null || stat=="" || stat == "Y"){
		    obj.btnstartstop.setVisible("true");
		    obj.btnstartstop.setText("停止");
	    }
	    else {
		    obj.btnstartstop.setVisible("true");
		    obj.btnstartstop.setText("启动");
	    }
	    }
	};
	
    obj.btnstartstop_click=function()
    {
	    if (obj.btnstartstop.getText()!=" ")
	    {
		    var rcicu=obj.retGridPanel.getSelectionModel().getSelected();
		    if(rcicu)
		    {
		        var icuaId=rcicu.get("icuaId");
		    }
		    else 
		    {
			    var icuaId="";
		    }
		    var rc = obj.retGridPanelequip.getSelectionModel().getSelected();
		    if(rc)
		    {
		        var equiprowid=rc.get("TRowid");
		        var stat=rc.get("TStat");
		        //alert(stat)
		        if(stat!="N")
		        {
			        ret=_DHCICUBedEquip.ModifyStat(equiprowid,icuaId,"N");
				    if(!ret){
				         alert("停止失败:"+ret);
			        }
			        else
			        {
			        alert("停止成功");
			        obj.retGridPanelequipStore.load({});
			        }
			        
		        }
		        else
		        {
			        ret=_DHCICUBedEquip.ModifyStat(equiprowid,icuaId,"Y");
				    if(!ret){
				         alert("启动失败:"+ret);
			        }
			        else
			        {
			        alert("启动成功");
			        obj.retGridPanelequipStore.load({});
			        }
		        }
		    }
	    }
    }
}

