var eprMessageTab = new Object();

eprMessageTab.readFlag = "";
eprMessageTab.executeFlag = "";
eprMessageTab.createDateStart = "";
eprMessageTab.createDateEnd = "";
var targetpos="";
var changePage=false;

(function($) {
    $(function() {

        var messageDG = $('#messageListTable').datagrid({
            url: '../web.eprajax.AjaxEPRMessage.cls',
            queryParams: {
                UserID: userId,
				UserType: 'RECEIVE',
				ReadFlag: '',
				ExecuteFlag: 'U',
				ConfirmFlag:'U',
				EffectiveFlag: 'E',
                Action: 'getmessage'
            },
            method: 'post',
            loadMsg: '加载中......',
            singleSelect: false,
            multiple:true,
            toolbar: toolbar,
            showHeader: true,
            scrollbarSize:10,
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'Name', title: '患者姓名', width: 80},
                { field: 'MessageID', title: '消息ID', width: 350, hidden: true },
                { field: 'MessageTitle', title: '消息', width: 310},
                { field: 'Message', title: '消息内容', width: 350, hidden: false },
                { field: 'SenderUserID', title: '发送者ID', width: 80, hidden: true },
                { field: 'SenderUserName', title: '发送者', width: 180, sortable: true },
                { field: 'CreateDateTime', title: '发送日期时间', width: 130, sortable: true, hidden: false },
                { field: 'ReceiverUserID', title: '接收者ID', width: 80, hidden: true },
                { field: 'ReceiverUserName', title: '接收者', width: 80, hidden: true }, 
				{ field: 'ReadFlag', title: 'ReadFlag', width: 80, hidden: true },
                { field: 'ReadDateTime', title: '阅读日期时间', width: 80, hidden: true },
                { field: 'ExecuteFlag', title: 'ExecuteFlag', width: 80,hidden: true},
                { field: 'Execute', title: '状态', width: 80},
                { field: 'ExecuteDateTime', title: 'ExecuteDateTime', width: 80, hidden: true },
                { field: 'Effective', title: '生效', width: 80, hidden: true },
                { field: 'EffectiveFlag', title: 'EffectiveFlag', width: 80, hidden: true },
                { field: 'EffectiveDateTime', title: 'EffectiveDateTime', width: 80, hidden: true },
                { field: 'MessageGroupID', title: 'MessageGroupID', width: 80, hidden: true },
                { field: 'MessageType', title: 'MessageType', width: 80, hidden: true },
                { field: 'MessageSource', title: '消息来源', width: 170, sortable: true },
				{ field: 'AppealText', title: '申诉', width: 350},
                { field: 'MessagePrioriry', title: 'MessagePrioriry', width: 80, hidden: true },
				{ field: 'EpisodeID', title: 'EpisodeID', width: 80, hidden: true },
				{ field: 'PatientID', title: 'PatientID', width: 80, hidden: true },
				{ field: 'Path', title: 'Path', width: 80, hidden: true },
                { field: 'ACKID', title: 'ACKID', width: 80, hidden: true }

            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            onLoadSuccess:function(data){
	        	if(MessageID)
	        	{
		        	for(i=0;i<data.rows.length;i++)
		        	{
			        	if(data.rows[i].MessageID==MessageID)
			        	{
				        	$('#messageListTable').datagrid("selectRow",i)
				        	break
				        }
			        }
		        }
	        },
            toolbar: '#messageListTableTBar',
			onDblClickRow: function(rowIndex, rowData){
				var episodeID = rowData.EpisodeID;
				var patientID = rowData.PatientID;
				var instanceId = rowData.InstanceId;
				var emrDocId = rowData.EmrDocId;
				var Path = rowData.Path;
				var MessageTitle=rowData.MessageTitle;
				if ((episodeID == "") || (episodeID == null)||(MessageTitle=="分配消息")) {
					return;
				}
				else {
					//var url = "emr.record.interface.csp?&EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+emrDocId+"&InstanceID="+instanceId+"&Path="+Path;
					if ((instanceId!="")&&(typeof instanceId!="undefind"))
					{
						var url = "emr.interface.ip.main.csp?&EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+emrDocId+"&InstanceID="+instanceId+"&Path="+Path;  
					}
					else
					{
						var url="websys.menugroup.csp?EpisodeID="+episodeID+"&MenuGroupID=56&PersonBanner=dhcdoc.patinfo.banner.csp&homeTab=ipdoc.patinfoview.csp&PatientListPage=inpatientlist.csp"
					}
					if('undefined' != typeof websys_getMWToken)
					{
						url += "&MWToken="+websys_getMWToken()
					}
					window.open (url,'newwindow','width='+ window.screen.width +',height='+ window.screen.height +',top=-33,left=3,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no') 
					
					//alert(episodeID);           
				}
			},
			loadFilter:function(data)
		   {
			   
			if ((MessageID)&&(changePage==false))
	        	{
		        	for(i=0;i<data.rows.length;i++)
		        	{
			        	if(data.rows[i].MessageID==MessageID)
			        	{
				        	targetpos=i;
				        	
				        }
			        }
		        }
		        
			  if(typeof data.length == 'number' && typeof data.splice == 'function'){
				  data={total: data.length,rows: data}
			  }
    		  var dg=$(this);
    		  var opts=dg.datagrid('options');
              var pager=dg.datagrid('getPager');
              
              pager.pagination({
    	      	onSelectPage:function(pageNum, pageSize){
	    	      	
	    	      	targetpos="";
	    	      	opts.pageNumber=pageNum;
        	 	  	opts.pageSize=pageSize;
        	     	pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
        	     	changePage=true;
        	     	dg.datagrid('loadData',data);
        	     	
	              
        	    }
              });
    		  if(!data.originalRows){
	    		  data.originalRows = (data.rows);
              }
              
              if (targetpos!="")
              {
	              var targetPageNum = parseInt(targetpos / opts.pageSize) + 1;
	              targetpos="";
	              opts.pageNumber = targetPageNum
	          	  var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	              var end = start + parseInt(opts.pageSize);
	              data.rows = (data.originalRows.slice(start, end));
	              
	              pager.pagination('refresh',{pageNumber:opts.pageNumber,pageSize:opts.pageSize});
	              
	                 
	          }
              else
              {
	              
	   		 	  var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	              var end = start + parseInt(opts.pageSize);
	              data.rows = (data.originalRows.slice(start, end));
	              
              }
              return data;
          }
        });
       
        //已读按钮事件
        $('#readBtn').on('click', function() {
            var gridRows = $('#messageListTable').datagrid("getChecked");
            if (gridRows.length == 0){
                //$.messager.alert('错误', '请至少选择一条记录！', 'error');
                return;           
            }
            
            var messageIDS = "";
            for (var i = 0; i < gridRows.length; i++) {
                var gridRow = gridRows[i];
                var messageID = gridRow["MessageID"];
                if (messageIDS == "") {
                    messageIDS = messageID;
                }
                else {
                    messageIDS = messageIDS + "^" + messageID;
                }
            }

            $.messager.confirm('确认已读选中消息', '确认已读选中消息？发送者会收到您的已读信息', function(r) {
                if (r) {
                    var ret = ""
                    var obj = $.ajax({
                        url: "../web.eprajax.AjaxEPRMessage.cls?Action=readmessage&MessageIDS=" + messageIDS + "&UserID=" + userId,
                        type: 'post',
                        async: false
                    });
                    var ret = obj.responseText;
                    if ((ret != "" || (ret != null)) && (ret != "-1")) {
                        $('#messageListTable').datagrid('reload');
                    }
                    else {
                        $.messager.alert('错误', '提交已读失败，请再次尝试！', 'error');
                    }
                }
            });
        });
        
        //已处理按钮事件
        $('#doneBtn').on('click', function() {
            var gridRows = $('#messageListTable').datagrid("getChecked");
            if (gridRows.length == 0){
                //$.messager.alert('错误', '请至少选择一条记录！', 'error');
                return;           
            }
            
            var messageIDS = "";
            for (var i = 0; i < gridRows.length; i++) {
                var gridRow = gridRows[i];
                var episodeID =gridRow["EpisodeID"];
                var messageID = gridRow["MessageID"];
                if (messageIDS == "") {
                    messageIDS = messageID;
                }
                else {
                    messageIDS = messageIDS + "^" + messageID;
                }
            }

            $.messager.confirm('确认已经处理完选中消息', '确认已经处理完选中消息？发送者会收到您的已处理此消息的信息', function(r) {
                if (r) {
                    var ret = ""
                    var obj = $.ajax({
                        url: "../web.eprajax.AjaxEPRMessage.cls?Action=donemessage&MessageIDS=" + messageIDS + "&UserID=" + userId+ "&EpisodeID=" + episodeID,
                        type: 'post',
                        async: false
                    });
                    var ret = obj.responseText;
                    if ((ret != "" || (ret != null)) && (ret != "-1")) {
                        $('#messageListTable').datagrid('reload');
                    }
                    else {
                        $.messager.alert('错误', '提交已处理失败，请再次尝试！', 'error');
                    }
                }
            });
        });
		
		$("#appealBtn").click(function(){
				 var gridRows = $('#messageListTable').datagrid("getChecked");
            if (gridRows.length == 0){
                //$.messager.alert('错误', '请至少选择一条记录！', 'error');
                return;           
            }
       
				$("#content").dialog({
					width:300,    
				    height:186,    
				    modal:true ,
				    title:'申诉',
				});
				$("#content").dialog("open");
				
			});
			
		  $("#appealOk").click(function(){
		 
			 var gridRows = $('#messageListTable').datagrid("getChecked");
				            if (gridRows.length == 0){
				                ///$.messager.alert('错误', '请至少选择一条记录！', 'error');
				                return;           
				            }
				            
				            var messageIDS = "";
				            var Appeal=$("#appealText").val();
				            if (Appeal == ""){
					        	 $.messager.alert('错误',"请填写申诉理由", 'error');    
					        }
					        else{
				            for (var i = 0; i < gridRows.length; i++) {
				                var gridRow = gridRows[i];
				                var messageID = gridRow["MessageID"];
				                
				                if (messageIDS == "") {
				                    messageIDS = messageID;
				                }
				                else {
				                    messageIDS = messageIDS + "^" + messageID;
				                }
				            }

				            $.messager.confirm('确认申诉', '确认申诉选中消息？发送者会收到您申诉此消息的信息', function(r) {
				                if (r) {
				                    var ret = ""
				                    var obj = $.ajax({
				                        url: "../web.eprajax.AjaxEPRMessage.cls?Action=donemessage&MessageIDS=" + messageIDS + "&UserID=" + userId+"&Appeal=" + encodeURI(Appeal),
				                        type: 'post',
				                        async: false
				                    });
				                    var ret = obj.responseText;
				                    if ((ret != "" || (ret != null)) && (ret != "-1")) {
				                        $('#messageListTable').datagrid('reload');
				                    }
				                    else {
				                        $.messager.alert('错误', '申诉失败，请再次尝试！', 'error');
				                    }
				                }
				            });
				            $("#content").dialog("close");
					        }
				    		 
		});
  		 $("#appealCancel").click(function(){
	  		$("#content").dialog("close");	
	  	});
        //给予操作类型
        $('#inputMessageType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: $g('未处理'),
                readFlag: '',
				executeFlag: 'U'
            },/* {
                id: '2',
                text: $g('已读'),
                readFlag: 'R',
				executeFlag: 'U'
            }, */{
                id: '3',
                text: $g('已处理'),
                readFlag: 'R',
				executeFlag: 'E'
			}],
            panelWidth: 300,
            showHeader: false,
			singleSelect: true,
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'readFlag', title: 'readFlag', width: 80, hidden: true },
				{ field: 'executeFlag', title: 'executeFlag', width: 80, hidden: true },
                { field: 'text', title: '消息类型', width: 250 }
            ]],
			onSelect: function() {
                var rows = $('#inputMessageType').combogrid('grid').datagrid('getChecked');
                var row = rows[0];
    
                eprMessageTab.readFlag = row["readFlag"];
                eprMessageTab.executeFlag = row["executeFlag"];
				
				$('#readBtn').show();
				$('#doneBtn').show();
				$('#appealBtn').show();
				if (eprMessageTab.readFlag == 'R'){
					$('#readBtn').hide();	
				}
				if (eprMessageTab.executeFlag == 'E'){
					$('#readBtn').hide();
					$('#doneBtn').hide();	
					$('#appealBtn').hide();	
				}
				refreshGrid();		
            },
			onLoadSuccess: function() {
                $('#inputMessageType').combogrid('grid').datagrid('selectRecord', 1);
            }
        });
		
				$('#inputCreateDateStart').datebox({    
			onSelect: function() {
				eprMessageTab.createDateStart = $('#inputCreateDateStart').datebox('getValue');
				refreshGrid();
            }			
		}); 

		$('#inputCreateDateEnd').datebox({    
			onSelect: function() {
				eprMessageTab.createDateEnd = $('#inputCreateDateEnd').datebox('getValue');
				refreshGrid();
            }			
		}); 		
		
		function refreshGrid(){
			var queryParams = $('#messageListTable').datagrid('options').queryParams;
            queryParams.ReadFlag = eprMessageTab.readFlag;
            queryParams.ExecuteFlag = eprMessageTab.executeFlag;
			queryParams.CreateDateStart = eprMessageTab.createDateStart;
			queryParams.CreateDateEnd = eprMessageTab.createDateEnd;

            $('#messageListTable').datagrid('options').queryParams = queryParams;
            $('#messageListTable').datagrid('reload');			
		}
    });
})(jQuery);

var toolbar =[{
			iconCls: 'icon-redo',
			text:'处理',
			handler: function(){
				
	            var gridRows = $('#messageListTable').datagrid("getChecked");
	            if (gridRows.length == 0){
	                //$.messager.alert('错误', '请至少选择一条记录！', 'error');
	                return;           
	            }
	            
	            var messageIDS = "";
	            for (var i = 0; i < gridRows.length; i++) {
	                var gridRow = gridRows[i];
	                var messageID = gridRow["MessageID"];
	                if (messageIDS == "") {
	                    messageIDS = messageID;
	                }
	                else {
	                    messageIDS = messageIDS + "^" + messageID;
	                }
	            }

	            $.messager.confirm('确认已经处理完选中消息', '确认已经处理完选中消息？发送者会收到您的已处理此消息的信息', function(r) {
	                if (r) {
	                    var ret = ""
	                    var obj = $.ajax({
	                        url: "../web.eprajax.AjaxEPRMessage.cls?Action=donemessage&MessageIDS=" + messageIDS + "&UserID=" + userId,
	                        type: 'post',
	                        async: false
	                    });
	                    var ret = obj.responseText;
	                    if ((ret != "" || (ret != null)) && (ret != "-1")) {
	                        $('#messageListTable').datagrid('reload');
	                    }
	                    else {
	                        $.messager.alert('错误', '提交已处理失败，请再次尝试！', 'error');
	                    }
	                }
	            });
			}
		}]
		