function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
    var but1=Ext.getCmp("mygridbut1");
	but1.on('click', LockSub);
	but1.setText("解锁");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	
	var grid = Ext.getCmp('mygrid');
	var tobar = grid.getTopToolbar();
		tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "解锁",
		handler: LockSub,
		id: 'mygridLock'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询所有",
		handler: function(){find(0)},
		id: 'mygridSch'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询异常(模板关键字段为空时由于没有保存过模板)",
		handler: function(){find(1)},
		id: 'mygridSch2'
	});
	
	tobar.doLayout();
    find(0);
}
function LockSub()
{
	var grid=Ext.getCmp('mygrid');
    
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
    var Item5=objRow[0].get("Item5");
	var Item2=objRow[0].get("Item2");
	var flag=tkMakeServerCall("NurMp.DHCMGNurComm","LockTime",Item5,Item2);
	if (flag!=0){
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '你确定要解锁？打开时长为'+flag+'秒,没有达到标准解锁时长（15分钟）',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	
	           var ret=tkMakeServerCall("NurMp.DHCMGNurComm","LockSub",Item5,Item2);
	            if (ret==0) alert("解锁成功！");
				else alert("解锁失败！");
				find(); 
	            }
					        else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	    });
	}else{
		 var ret=tkMakeServerCall("NurMp.DHCMGNurComm","LockSub",Item5,Item2);
		  if (ret==0) alert("解锁成功！");
		  else alert("解锁失败！");
		  find(); 
	}
	}
}
function find(flag)
{
var mygrid = Ext.getCmp("mygrid");
	var parr=flag;
    mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    });  
    mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })	
}