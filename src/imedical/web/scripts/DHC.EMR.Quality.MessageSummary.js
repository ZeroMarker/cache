
var eprMessageSummary = new Object();

eprMessageSummary.selectDocLocID = "";
eprMessageSummary.selectSSGroupID = "";
eprMessageSummary.readFlag = "";
eprMessageSummary.executeFlag = "";
eprMessageSummary.createDateStart = "";
eprMessageSummary.createDateEnd = "";
eprMessageSummary.locID = "";
eprMessageSummary.MessageDesc = "";

    $(function() {
	    if(HISUIStyleCode == "lite"){
	    $(".div_center").css({'background-color':'#f5f5f5'});
		}
	    initcombox();
	    $('#ConfirmBtn').hide()
	   
		
		
        var messageDG = $('#messageListTable').datagrid({
            url: '../web.eprajax.AjaxEPRMessage.cls',
            queryParams: {
                UserID: userID,
				UserType: 'SEND',
				ReadFlag: '',
				ExecuteFlag: 'U',
				ConfirmFlag:'U',
				EffectiveFlag: 'E',
				CreateDateStart: '',
				CreateDateEnd: '',
                LocID :'',
                Action: 'getmessage',
                MessageDesc: ''
            },
            method: 'post',
            loadMsg: '加载中......',
            singleSelect: false,
            checkOnSelect:false,
            multiple:true,
            showHeader: true,
            fitColumns: true,
            columns: [[
               { field: 'ck', title: '勾选框',checkbox: true },
                { field: 'Name', title: '患者姓名', width: 70},
                { field: 'MessageID', title: '消息ID', width: 250, hidden: true },
                { field: 'MessageTitle', title: '消息', width: 150},
                { field: 'Message', title: '消息内容', width: 300 },
                { field: 'SenderUserID', title: '发送者ID', width: 80, hidden: true },
                { field: 'SenderUserName', title: '发送者', width: 80, sortable: true},
                { field: 'CreateDateTime', title: '发送日期时间', width: 80, sortable: true},
                { field: 'ReceiverUserID', title: '接收者ID', width: 80, hidden: true },
                { field: 'ReceiverUserName', title: '接收者', width: 70 },
				{ field: 'CtLocName', title: '责任科室', width: 70 },				
                { field: 'ExecuteFlag', title: 'ExecuteFlag', width: 80, hidden: true },
                { field: 'ExecuteDateTime', title: '执行日期时间', width: 80},
				{ field: 'AppealText', title: '申诉', width: 200}, 
				{field:'MesStep',title:'消息流程',width:100,align:'center',
					formatter:function(value,row,index){ 
					return '<span style="color:#449be2;cursor:pointer">流程图查看</span>'
					}
				},
                { field: 'Effective', title: '生效', width: 80, hidden: true },
                { field: 'EffectiveFlag', title: 'EffectiveFlag', width: 80, hidden: true },
                { field: 'EffectiveDateTime', title: 'EffectiveDateTime', width: 80, hidden: true },
                { field: 'MessageGroupID', title: 'MessageGroupID', width: 80, hidden: true },
                { field: 'MessageType', title: 'MessageType', width: 80, hidden: true },
                { field: 'MessageSource', title: '消息来源', width: 80, sortable: true, hidden: true },
                { field: 'MessagePrioriry', title: 'MessagePrioriry', width: 80, hidden: true },
				{ field: '.,', title: 'EpisodeID', width: 80, hidden: true },
				{ field: '..,', title: 'PatientID', width: 80, hidden: true },
                { field: 'ACKID', title: 'ACKID', width: 80, hidden: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#messageListTableTBar',
            onClickRow: function(rowIndex, rowData) {
				$('#inputReceiveUserName').val(rowData.ReceiverUserName);
				$('#inputReceiveUserID').val(rowData.ReceiverUserID);
            },
			onDblClickRow: function(rowIndex, rowData){
				var episodeID = rowData.EpisodeID
				var patientID=rowData.PatientID;
				//var url = "emr.record.browse.csp?&EpisodeID="+episodeID;
				if (QuaSetPage=="2")
	            {   
				var url = "emr.browse.quality.csp?&PatientID="+patientID+"&EpisodeID="+episodeID+"&InstanceID="+rowData.InstanceId+"&Path="+rowData.Path;
	            }
	            else
	            {
		            var url = "emr.record.fullquality.csp?&EpisodeID="+episodeID; 
		        }
		        if('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken()
				}
				window.open (url,'newwindow','height=800,width=1280,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no') 
				//alert(episodeID);
			},
			onClickCell: function(rowIndex, field, value) {
				var rows = $('#messageListTable').datagrid('getRows');
				var row = rows[rowIndex];
				var MessageID = row.MessageID;
				if(field =='MesStep'){
					var urlstr = "dhc.emr.quality.messagestep.csp?&MessageID="+MessageID;
					if('undefined' != typeof websys_getMWToken)
					{
						urlstr += "&MWToken="+websys_getMWToken()
					}
					websys_showModal({
						iconCls:'icon-w-msg',
						url:urlstr,
						title:$g('消息流程图'),
						width:420,height:280
						});	
					//createModalDialog("QualityMesDialogD","消息流程图","400","250","iframeQualityMes","<iframe id='iframeQualityMes' scrolling='auto' frameborder='0' src='" + urlstr +"' style='width:400px; height:200px; display:block;'></iframe>","","")
				}
			},
			 loadFilter:function(data)
		  {
			  if(typeof data.length == 'number' && typeof data.splice == 'function'){
				  data={total: data.length,rows: data}
			  }
    		  var dg=$(this);
    		  var opts=dg.datagrid('options');
              var pager=dg.datagrid('getPager');
              pager.pagination({
    	      	onSelectPage:function(pageNum, pageSize){
	    	      	opts.pageNumber=pageNum;
        	 	  	opts.pageSize=pageSize;
        	     	pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
        	     	dg.datagrid('loadData',data);
        	    }
              });
    		  if(!data.originalRows){
	    		  data.originalRows = (data.rows);
              }
   		 	  var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
              var end = start + parseInt(opts.pageSize);
              data.rows = (data.originalRows.slice(start, end));
              return data;
          }
        });

		//切换按钮
		function radioCheck(d,value)
		{
			if (d=='uMessageRadio')
			{
				$('#ConfirmBtn').hide()
			}
			if (d=='eMessageRadio')
			{
				$('#ConfirmBtn').show()
			}
			if (d=='cMessageRadio')
			{
				
				$('#ConfirmBtn').hide()
			}
			$('#selectDec').searchbox("setValue", "");
			var RadioValue = value;
			var arr = RadioValue.split("|"); 
			eprMessageSummary.readFlag = arr[0];
		    eprMessageSummary.executeFlag = arr[1];
		    eprMessageSummary.confirmFlag = arr[2];
			var queryParams = $('#messageListTable').datagrid('options').queryParams;
		    queryParams.ReadFlag = eprMessageSummary.readFlag;
		    queryParams.ExecuteFlag = eprMessageSummary.executeFlag;
		    queryParams.ConfirmFlag = eprMessageSummary.confirmFlag;
			queryParams.CreateDateStart = eprMessageSummary.createDateStart;
			queryParams.CreateDateEnd = eprMessageSummary.createDateEnd;
                                    queryParams.LocID = eprMessageSummary.locID;
            queryParams.MessageDesc = '';
		    $('#messageListTable').datagrid('options').queryParams = queryParams;
		    $('#messageListTable').datagrid('reload');			

		}
		      
		 function Confirm() {
		    //alert("暂时不支持！");  
			//已修复事件
		    var gridRows = $('#messageListTable').datagrid("getChecked");
		    if (gridRows.length == 0){
		        $.messager.alert('提示', '请至少选择一条记录！', 'error');
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
		    var ret = ""
		    var obj = $.ajax({
		        url: "../web.eprajax.AjaxEPRMessage.cls?Action=confirmmessage&MessageIDS=" + messageIDS + "&UserID=" + userID,
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
		
		$HUI.radio("[name='msgTypeRadio']",{
            onChecked:function(e,value){
               radioCheck($(e.target).attr("id"),$(e.target).attr("value"))
            }
        });
		$HUI.radio("#uMessageRadio").setValue(true);	
        //确认已修复 
        $('#ConfirmBtn').on('click', function() {
            Confirm();
 		});
                                   
                               //导出表格
        $('#makeExcelBtn').on('click', function() {
            makeExcel();
 		});                                

		$('#inputCreateDateStart').datebox({    
			onChange: function() {
				eprMessageSummary.createDateStart = $('#inputCreateDateStart').datebox('getValue');
				refreshGrid();
            },
            onSelect: function() {
				eprMessageSummary.createDateStart = $('#inputCreateDateStart').datebox('getValue');
				refreshGrid();
            }			
		}); 

		$('#inputCreateDateEnd').datebox({  
		    onChange: function() {
				eprMessageSummary.createDateEnd = $('#inputCreateDateEnd').datebox('getValue');
				refreshGrid();
            },			  
			onSelect: function() {
				eprMessageSummary.createDateEnd = $('#inputCreateDateEnd').datebox('getValue');
				refreshGrid();
            }			
		}); 
		
		$('#selectDec').searchbox({
        	searcher:function(value,name){
    		var SelectDec=value;        	
        	eprMessageSummary.MessageDesc = SelectDec;
			refreshGrid();
		
    }
   
});		
		$('#ctLocID').combobox
	 ({
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetAllCTLocID&Type=E&HospitalID='+HospitalID,
		mode:'remote',
		onChange: function (n,o) {
			$('#ctLocID').combobox('setValue',n);
		    var newText = $('#ctLocID').combobox('getText');
			$('#ctLocID').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetAllCTLocID&Type=E&HospitalID='+HospitalID+'&Filter='+encodeURI(newText.toUpperCase()));
		    eprMessageSummary.locID = $("#ctLocID").combobox('getValue');
		   
		    refreshGrid();
		},
		onSelect: function(record){
		eprMessageSummary.locID = $("#ctLocID").combobox('getValue');
		refreshGrid();	
	    } 
    });

                                	//导出excel
        function makeExcel()
        {
	        
	         var options = $('#messageListTable').datagrid('getPager').data("pagination").options; 
             var curr = options.pageNumber; 
             var total = options.total;
             var pager = $('#messageListTable').datagrid('getPager');
             var rows = [] 
             var limit=(total/options.pageSize)
             if (Math.floor(limit)!=limit)
             {
	             var limit= limit+1
	          }
            for (i=1;i<=limit;i++)
            {
	             pager.pagination('select',i);
                 pager.pagination('refresh');
                 var currows =  $('#messageListTable').datagrid('getRows');
                 if (currows.length==0)
                 {
	                 continue;
	             }
           for (var j in currows)
           {
	            rows.push(currows[j]);
	        }
         
	    }
	     
	      pager.pagination('select',curr);
          pager.pagination('refresh');
	      $('#messageListTable').datagrid('toExcel',{
		  filename:'messageListTable.xls',
		  rows:rows
		});
	}		

		function refreshGrid(){
			var queryParams = $('#messageListTable').datagrid('options').queryParams;
            //queryParams.ReadFlag = eprMessageSummary.readFlag;
            //queryParams.ExecuteFlag = eprMessageSummary.executeFlag;
			queryParams.CreateDateStart = eprMessageSummary.createDateStart;
			queryParams.CreateDateEnd = eprMessageSummary.createDateEnd;
                                                queryParams.LocID = eprMessageSummary.locID;
			queryParams.MessageDesc = eprMessageSummary.MessageDesc;
            $('#messageListTable').datagrid('options').queryParams = queryParams;
            $('#messageListTable').datagrid('reload');			
		}
		
	    //医生查询列表
        var docDG = $('#docListTable').datagrid({
            url: '../web.eprajax.GivePower.cls',
            queryParams: {
                Action: 'doclist',
                DocSSGroupID: '',
                DocLocID: '',
                //DocUserCode: '',
                DocUserName: ''
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: true,
            showHeader: true,
            fitColumns: true,
            columns: [[
                { field: 'SSUserID', title: '用户ID', width: 80, sortable: true },
                { field: 'UserName', title: '医生名字', width: 80, sortable: true },
                { field: 'UserCode', title: '医生用户名', width: 80, sortable: true },
                { field: 'CTLocID', title: '医生所属科室ID', width: 80, sortable: true },
                { field: 'SSGroupID', title: '医生所属安全组ID', width: 80, sortable: true },
                { field: 'CTLoc', title: '医生所属科室', width: 80, sortable: true },
                { field: 'SSGroup', title: '医生所属安全组', width: 80, sortable: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#docListTableTBar',
            //title: '医生查询',
            onClickRow: function(rowIndex, rowData) {
				$('#inputReceiveUserName').val(rowData.UserName);
				$('#inputReceiveUserID').val(rowData.SSUserID);
            }
        });

        //选择医生所在科室
		function initcombox()
		{
			$('#inputDocLoc').combobox
			({
				valueField:'ID',  
				textField:'Name',
				url:'../web.eprajax.usercopypastepower.cls?Action=GetAllCTLocID&Type=E&HospitalID='+HospitalID,
				mode:'remote',
				onChange: function (n,o) {
					$('#inputDocLoc').combobox('setValue',n);
					var newText = $('#inputDocLoc').combobox('getText');
					$('#inputDocLoc').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetAllCTLocID&Type=E&HospitalID='+HospitalID+'&Filter='+encodeURI(newText.toUpperCase()));
				},
				onSelect: function(record){
					
				} 
			});
		}

        //选择医生所在安全组
        $('#inputDocSSGroup').combogrid({
            url: '../web.eprajax.DicList.cls',
            queryParams: {
                Action: 'ssgroup',
                Filter: ''
            },
            panelWidth: 300,
            idField: 'ID',
            textField: 'DicDesc',
            method: 'get',
            showHeader: false,
            fitColumns: true,
            columns: [[
                { field: 'ID', title: 'ID', width: 80, hidden: true },
                { field: 'DicDesc', title: 'DicDesc', width: 250 }
            ]],
            pagination: true,
            pageSize: 10,
            pageList: [5, 10, 20],
            keyHandler: {
                query: function(q) {
                    //动态搜索
                    var queryParams = $('#inputDocSSGroup').combogrid('grid').datagrid('options').queryParams;
                    queryParams.Filter = q;
                    $('#inputDocSSGroup').combogrid('grid').datagrid('options').queryParams = queryParams;
                    $('#inputDocSSGroup').combogrid('grid').datagrid('reload');
                    $('#inputDocSSGroup').combogrid("setValue", q);
                }
            },
            onSelect: function() {
                eprMessageSummary.selectSSGroupID = "";
                var rows = $('#inputDocSSGroup').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprMessageSummary.selectSSGroupID = row["ID"];
                searchDoc();
            }
        });

        function searchDoc() {
            var queryParams = $('#docListTable').datagrid('options').queryParams;
            queryParams.DocLocID = $("#inputDocLoc").combobox('getValue');
            //queryParams.DocLocID = eprMessageSummary.selectDocLocID;
            queryParams.DocSSGroupID = eprMessageSummary.selectSSGroupID;
            //queryParams.DocUserCode = $('#inputDocUserCode').val();
            queryParams.DocUserName = $('#inputDocName').val();

            $('#docListTable').datagrid('options').queryParams = queryParams;
            $('#docListTable').datagrid('reload');
        }
			
        //查询医生
        $('#docSearchBtn').on('click', function() {
            //debugger;
            searchDoc();
        });

        //清空医生查询条件
        $('#docResetBtn').on('click', function() {
            //$('#inputDocUserCode').val('');
            $('#inputDocName').val('');
            $('#inputDocLoc').combobox('setValue','');
           // $('#inputDocLoc').combogrid("setValue", '');
            $('#inputDocSSGroup').combogrid("setValue", '');
            eprMessageSummary.selectDocLocID = "";
            eprMessageSummary.selectSSGroupID = "";
        });

        //输入框enter事件
        /*$('#inputDocUserCode').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchDoc();
            }
        });*/

        $('#inputDocName').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchDoc();
            }
        });  

        $('#inputPriority').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '重要',
                value: 'E'
            }, {
                id: '2',
                text: '普通',
                value: 'N'
			}],
            panelWidth: 350,
            showHeader: false,
			singleSelect: true,
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'value', title: 'value', width: 80, hidden: true },
                { field: 'text', title: '紧急程度', width: 250 }
            ]],
			onLoadSuccess: function() {
                $('#inputPriority').combogrid('grid').datagrid('selectRecord', 2);
				$('#inputPriorityValue').val("N");
            },
            onSelect: function() {
	            var gridRows = $('#docListTable').datagrid("getSelections");
                var gridRow = gridRows[0];
                var receiveUserID = ""
                if (gridRows.length == 0) {
                   
                    return;
                }
                else {
                var rows = $('#inputPriority').combogrid('grid').datagrid('getChecked');
                var row = rows[0];
                $('#inputPriorityValue').val(row["value"]);
                }
              
               
            }
        });	

		$('#sendBtn').on('click', function() {
			/*var gridRows = $('#docListTable').datagrid("getSelections");
                var gridRow = gridRows[0];
                var receiveUserID = ""
                if (gridRows.length == 0) {
                    $.messager.alert('错误', '请选择一位医生！', 'error');
                    return;
                }
                else {
                    receiveUserID = $('#inputReceiveUserID').val();
                }*/
				receiveUserID = $('#inputReceiveUserID').val();
				var messageHeader = $('#inputMessageHeader').val();
				if ($('#inputReceiveUserName').val() == "") {
                    $.messager.alert('错误', '请选择收件人！', 'error');
                    return;
                }
                if (messageHeader == "") {
                    $.messager.alert('错误', '请输入消息标题！', 'error');
                    return;
                }
 
				var message = $('#inputMessage').val();
                if (message == "") {
                    $.messager.alert('错误', '请输入消息内容！', 'error');
                    return;
                }

				var priority = $('#inputPriorityValue').val();

                //确认发送
                var msg = "<p>"+$g('确定发送消息？')+"</p>"
                         + "<p>"+$g('医生')+"： 《" + $('#inputReceiveUserName').val() + "》 </p>"
                         + "<p>"+$g('消息头')+"： 《" + messageHeader + "》 </p>"
                         + "<p>"+$g('消息内容')+"： 《" + message + "》 </p>";

                $.messager.confirm('确认发送', msg, function(r) {
                    if (r) {
                        var ret = ""
                        var QualityMessageItemRows = $('#messageListTable').datagrid('getChecked'); 
	
	                     if (QualityMessageItemRows.length == 0) 
	                     {	
			               $.messager.alert("提示","请勾选上方对应患者！");
			               return;
	                     }
	
	
	
	                   for(var i=0; i<QualityMessageItemRows.length; i++){
		
		
		               var episodeID = QualityMessageItemRows[i].EpisodeID;
		               
		               var LocId=QualityMessageItemRows[i].LocID;
		               
	                   }
                        var obj = $.ajax({
                            url: "../web.eprajax.AjaxEPRMessage.cls?Action=send&UserID=" + userID + "&ReceiveUserID=" + receiveUserID + "&MessageHeader=" + encodeURI(messageHeader) + "&Message=" + encodeURI(message) + "&MessageSource=QUALITY&EpisodeID=" + episodeID + "&Priority=" + priority+'&LocID='+LocId,
                            type: 'post',
                            async: false
                        });
                        var ret = obj.responseText;
                        if ((ret != "" || (ret != null)) && (ret != "-1")) {
                            $.messager.alert('完成', '发送成功！', 'info');
                            $('#messageListTable').datagrid('reload');
                        }
                        else {
							
                            $.messager.alert('错误', '发送失败，请再次尝试！', 'error');
                        }
                    }
                });
            });		
    })
