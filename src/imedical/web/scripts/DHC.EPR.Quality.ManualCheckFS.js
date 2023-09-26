function send()
{
	var selections1 = MessageGrid1.getSelectionModel().getSelections();
	//var selections1 = MessageGrid1.getStore();
	if (selections1.length == 0) 
	{
			alert("请选择发送条目!");
			return;
	}
	var SendData = "";
	var SendDatas = "";
	
	for (var i =0; i<selections1.length; i++)
	//for (var i = 0; i < selections1.getCount(); i++)
	{
		//var record = selections1.getAt(i);
		var record = selections1[i];
		var EntryName = record.get("EntryName");
		var ResumeText = record.get("ResumeText");
		//alert(ResumeText);
		var EmployeeID = record.get("EmployeeID");
		var SignUserID = record.get("SignUserID");
		var EmployeeName = record.get("EmployeeName");
		var InstanceId = record.get("InstanceId");
		var EmrDocId = record.get("EmrDocId");
		var EntryScore = record.get("EntryScore");
		var EntryID = record.get("EntryID");
		var ExamCount = record.get("ExamCount");
		var ResultDetailID = record.get("ResultDetailID");
		if (SendData == "")
		{
			var SendData = EntryName  + " 责任医生：" + EmployeeName + " 备注：" + ResumeText;
		}
		else
		{
			var SendData = SendData + "<br/>" + EntryName + " 责任医生：" + EmployeeName + " 备注：" + ResumeText;
		}
		if (SendDatas == "")
		{
			
			var SendDatas = EntryName +  "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID;
		}
		else
		{
			
			var SendDatas = SendDatas + "&" + EntryName + "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID;
		}
		
	}
	 Ext.Ajax.request({
		url: '../EPRservice.Quality.SaveManualResult.cls',
		params: {SendDatas:SendDatas},
		success: function(response, options){
			var ret = response.responseText;
			if (ret == 0 )
			{
				alert("发送失败！");
				return;
			}
			else if (ret == 1)
			{
				alert("发送成功！");
				Ext.getCmp('MessageGrid1').store.reload();
				if (Action =="A")
				{
					SetAdmManualFlag();
				}
			}

		}
	})         
	/*
    Ext.MessageBox.show({  
                    title: '消息内容',  
                    buttons: Ext.Msg.OKCANCEL,  
                    width: 500,
                    closable: false,  
                    msg: "已选择评分项：" + "<br/>" + SendData,  
                    fn: function(e, text) { 
	                    if (e == 'ok'){
	                        //Ext.MessageBox.alert('您点击的是' + e + "输入的内容为: " + text + SendData);
	                        SendDatas = SendDatas + "||" + text;
	                        Ext.Ajax.request({
							url: '../EPRservice.Quality.SaveManualResult.cls',
							params: {SendDatas:SendDatas,emrDocId:emrDocId,InstanceId:InstanceId},
							success: function(response, options){
								var ret = response.responseText;
								if (ret == 0 )
								{
									alert("发送失败！");
									return;
								}
								else if (ret == 1)
								{
									alert("发送成功！");
									Ext.getCmp('MessageGrid1').store.reload();
								}
			
							}
						})         
                    }
                    },  
                    prompt: true,  
                    multiline: true  
                });  */
}
function delet()
{
	//alert(SSGroupID);
	//alert(KSSGroup);
	var EntryScores = 0
	var selections1 = MessageGrid1.getSelectionModel().getSelections();
	if (selections1.length == 0) 
	{
		
				//Ext.getCmp('MessageGrid1').Bbar.render();
			alert("请选择删除手工评分项!");
			return;
	}
	var DelData="";
	for (var i=0; i<selections1.length; i++)
	{
		//debugger;
		var record = selections1[i];
		var UserID = record.get("SignUserID");
		if ((SignUserID!=UserID)&&(SSGroupID==KSSGroup))
		{
			alert("无权删除其它质控医生条目！");
			return;
		}
		var ResultID = record.get("ResultID");
		var DetailID = record.get("DetailID");
		var EntryScore = record.get("EntryScore");
		if (DelData == "")
		{
			var DelData = ResultID + "||" + DetailID;
		}
		else
		{
			var DelData = DelData + '&' + ResultID + "||" + DetailID;
		}
		var EntryScores = EntryScores*1+EntryScore*1
	}
	Ext.Ajax.request({
		url: '../EPRservice.Quality.SaveManualResult.cls',
		params: {DelData:DelData},
		success: function(response, options){
			var ret = response.responseText;
			if (ret == 0 )
			{
				alert("删除失败！");
				return;
			}
			else if (ret == 1)
			{
				alert("删除成功！");
				var text = Ext.getCmp('btnScore').getText();
				var score =  text.slice(5);
				Ext.getCmp('MessageGrid1').store.reload();
				Ext.getCmp('btnScore').setText("病案得分:"+(score*1+EntryScores*1));
			}
			
		}
	}) 
}
var Action = action
if (Action=="A")
{
	var pre = true; 
}
if (Action=="D")
{
	var pro = true; 
}
var Bbar = ["->",{
					id:'btnSend',
					text:'发送消息',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/send.png',
					pressed:false,
					//hidden : pro?true:false,
					handler:send
				}					
				,{
					id:'btnSure',
					text:'删除',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/delete.png',
					pressed:false,
					handler:delet
				}];		
var store = new Ext.data.Store({
		url : '../EPRservice.Quality.GetQualityResult.cls',
		baseParams: {RuleID:RuleID,EpisodeID:EpisodeID,SSGroupID:SSGroupID,CTLocatID:CTLocatID,Action:action},
		reader : new Ext.data.JsonReader({
			totalProperty : "TotalCount",
			root : 'data'
		}, ['CtLocName','EmployeeName','EntryName','SignUserName','ReportDate','EntryID','EntryScore','LocID','EmployeeID','ResultID','DetailID','SignUserID','ResumeText','InstanceId','EmrDocId','ExamCount','ResultDetailID','MessageFlag'])
	});
    var sm = new Ext.grid.CheckboxSelectionModel({
		 handleMouseDown: Ext.emptyFn,
		 renderer: function(v, c, r){
				//重写CheckboxSelectionModel的Renderer，已发送消息，不显示行头的复选框
				if (r.get('MessageFlag') != '0') {
					return " ";
				}
				//原本行头的复选框
				else {
					return '<div class="x-grid3-row-checker">&#160;</div>';
				}
			} });
    var addColsCM = new Ext.grid.ColumnModel([
		sm,
		{
			header:'评估项目',
			dataIndex:'EntryName',
			width:230,
			renderer: function(value, meta, record) {
				meta.attr = 'style="white-space:normal;word-wrap:break-word;word-break:break-all;"';
            	return value;}
		},
		{
			header:'备注',
			dataIndex:'ResumeText',
			//width:100,
			renderer: function(value, meta, record) {
				meta.attr = 'style="white-space:normal;word-wrap:break-word;word-break:break-all;"';
            	return value;}
		},
		{
			header:'质控员',
			dataIndex:'SignUserName',
		    width:50
		},
		{
			header:'质控日期',
			dataIndex:'ReportDate',
			width:70
		},
		{
			header:'责任科室',
			dataIndex:'CtLocName',
			width:70
		},
		{
			header:'责任人',
			dataIndex:'EmployeeName',
			width:50
		}
	]);
    var MessageGrid1 = new Ext.grid.EditorGridPanel({
	    	el:"ChangeFS",
			id: 'MessageGrid1',
			frame: true,
			region: 'center',
			//autoScroll: true,
			//height: 599,
			//width: 540,
			store: store,
			cm: addColsCM,
			sm: sm,
			clicksToEdit:1,
			bbar: Bbar,
			stripeRows: true,
			listeners:{
       			render:function(){
             	var hd_checker = this.getEl().select('div.x-grid3-hd-checker');
             	if (hd_checker.hasClass('x-grid3-hd-checker')) {  
                    hd_checker.removeClass('x-grid3-hd-checker');  // 去掉全选框
             	} 
				}
			}
    	});
	MessageGrid1.render();
	store.load();
	store.on('load', function(){
		if('IE11.0'==isIE()){
			Ext.getCmp('MessageGrid1').addClass('ext-ie');
		}
    //OutGridChangeRowBackColor(Ext.getCmp('dgResultGrid'));
	});

function SetAdmManualFlag() {
	//alert(SignUserID)
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,SignUserID:SignUserID,Action:"Set",Status:"A",SSGroupID:SSGroupID,IsMessage:"1"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				//alert("确认成功！");
				window.parent.parent.doSearch();
				return;
			}
		}
	}) 		
}
	
	
	
	function isIE(){
	var userAgent = navigator.userAgent, 
	rMsie = /(msie\s|trident.*rv:)([\w.]+)/; 
	var browser; 
	var version; 
	var ua = userAgent.toLowerCase(); 
	function uaMatch(ua){ 
		var match = rMsie.exec(ua); 
		if(match != null){ 
			return { browser : "IE", version : match[2] || "0" }; 
		}
	} 
	var browserMatch = uaMatch(userAgent.toLowerCase()); 
	if (browserMatch.browser){ 
		browser = browserMatch.browser; 
		version = browserMatch.version; 
	} 
	return(browser+version);
}
