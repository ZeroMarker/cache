var Manager;

var groupIDs = "";
var queryInput = "";
(function($) {

    $(function() {

        //solr连接
        Manager = new AjaxSolr.Manager({
            solrUrl: solrUrl
        });

        //添加返回结果
        Manager.addWidget(new AjaxSolr.ResultWidget({
            id: 'result',
            target: '#docs'
        }));

        //添加分页
        Manager.addWidget(new AjaxSolr.PagerWidget({
            id: 'pager',
            target: '#pager',
            prevLabel: '上一页',
            nextLabel: '下一页',
            innerWindow: 5
        }));

        function enter4Request(inputQueryString) {
            Manager.init();
            Manager.store.remove('fq');

            //q - 待查询语句
            //hl - 高亮开关
            //hl.fl - 要高亮的filed
            //hl.simple.pre - 高亮文本的前置标签
            //hl.simple.post - 高亮文本的后置标签
            //hl.fragsize - 高亮文本所在前后的字符数，比如搜索北京，则这个设置返回北京这个词前100个字符和后100个字符 为结果
            //hl.snippets - 一个field中同一个高亮词高亮的数，比如搜索北京，在一个field中一共有10个北京要是snippets设 为3，只显示前3个
            var params = null;

            params = {
                'q': inputQueryString,
                'q.op' : queryOption,
                'hl': 'true',
                'hl.fl': '*',
                'hl.simple.pre': '<span class="highlighting"><font color="red">',
                'hl.simple.post': '</font></span>',
                'hl.fragsize': '300',
                'hl.snippets': '100'
            };

            for (var name in params) {
                Manager.store.addByValue(name, params[name]);
            }

            var strs = new Array();
            strs = groupIDs.split('|');
            for (var i = 0; i < strs.length; i++) {
				var fq = "";
                var groupID = strs[i].split('^')[0];
                var nodes = $('#fqpgTree' + groupID).tree("getChecked");    // 获取树中所有选中的行
				if (nodes&&nodes.length>0) {
					var node = null;
					for (var j = 0; j < nodes.length; j++) {
						var node = nodes[j];
						var itemID = node.id;
						var nodeStrs = new Array();
						nodeStrs = itemID.split('_');
						if (nodeStrs[0] == "SG")
						{
							continue;	
						}
						var group = node.attributes.groupName;
						
						if (fq == "") {
							fq = group + ":" + itemID;
						}
						else {
                        	fq = fq + " || " + group + ":" + itemID;
						}
					}
				}
				// 处理age和disDate参数
				if (strs[i].split('^')[1] == "Age")
				{
					//先处理年龄
					var ageFrom = $("#ageStart").numberbox('getValue');
					var ageTo = $("#ageEnd").numberbox('getValue');				
					if (ageTo && ageFrom)
					{
						fq = "Age:[" + ageFrom + " TO " + ageTo + "]"
					}
					else if (ageFrom)
					{
						fq = "Age:[" + ageFrom + " TO *]"
					}
					else if (ageTo)
					{
						fq = "Age:[* TO " + ageTo + "]"
					}
				}
				if (strs[i].split('^')[1] == "DisDate")
				{
					//再处理日期
					var dateFrom = $("#dateStart").datebox('getValue');
					var dateTo = $("#dateEnd").datebox('getValue');
					var prefix = "T00:00:00Z"
					if (dateFrom && dateTo)
					{
						fq = "DisDate:[" + dateFrom+prefix + " TO " + dateTo+prefix + "]"
					}
					else if (dateFrom)
					{
						fq = "DisDate:[" + dateFrom+prefix + " TO *]"
					}
					else if (dateTo)
					{
						fq = "DisDate:[* TO " + dateTo+prefix + "]"
					}
				}
				//处理查询
				if (fq != "") {
					Manager.store.addByValue('fq', fq);
				}
            }

		//默认增加院区处理
		Manager.store.addByValue('fq', “HosAreaID:”+hospid);
            //debugger;
            var ret = ""
            var obj = $.ajax({ url: "../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls?Action=getmrepisodeids&UserID=" + userID, async: false });
            var ret = obj.responseText;
            if ((ret != "") || (ret != null)) {
                Manager.store.addByValue('fq', ret);
            }
			if (wordCollect == "Y") {
				if ((inputQueryString != "" )|| (inputQueryString != null)) {
					var objAddWord = $.ajax({ url: "../DHCEPRSearch.web.eprajax.AjaxCustomWordDic.cls?Action=addword&Word=" + encodeURI(inputQueryString) + "&CTLocID="+ctLocID+"&SSGroupID="+ssGroupID+"&UserID="+userID, async: false });
				}
			}
		
            Manager.doRequest();
        }
        function doSearch(qValue) {
            //debugger;
            $('#saveQuery').val(qValue);

            if (qValue != "") {
                enter4Request(qValue);
            }
            else {
                enter4Request('*:*');
            }
        }


        $('#query').searchbox({
            searcher: function(value) {
                queryInput = value;
                doSearch(value);
            },
            width: 500
        });

        $('#fqpg').accordion({
            animate: true,
            border: false,
            multiple: true,
            width: 290
        });

        //我的文库
        $('#myDocButton').on('click', function() {
            $('#myDocWin').window({
                width: 1000,
                height: 500,
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closable: true,
                title: '我的文库',
                href: cspBaseUrl + 'dhc.epr.search.mydoc.csp?UserID=' + userID + '&DataServiceUrl=' + dataServiceUrl
            });
        });

        //导入结果
        $('#importButton').on('click', function() {
            $('#importWin').window({
                width: 1000,
                height: 500,
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closable: true,
                title: '导入结果',
                href: cspBaseUrl + 'dhc.epr.search.import.csp?UserID=' + userID + '&DataServiceUrl=' + dataServiceUrl,
                onClose: function() {
                    doSearch(queryInput);
                }
            });
        });



        //右侧过滤菜单
        //1.自定义
        var category = [
        	{
	        	id: 4,
	        	itemName: "DisDate",
	        	itemDesc: "出院时间"
	        },
	        {
		        id: 5,
	        	itemName: "Gender",
	        	itemDesc: "性别"
		    },
		    {
		        id: 6,
	        	itemName: "Age",
	        	itemDesc: "年龄"
		    }
        ]
        var GenderInfo = [{
			id:"SG_51",text: '性别', state: 'open',
			children:[{
				id:"男",text: '男', state: 'open', attributes: {groupName:'Gender'},
			},{
				id:"女",text: '女', state: 'open', attributes: {groupName:'Gender'}
			}]
		}]
        
        var obj = $.ajax({ url: "../DHCEPRSearch.web.eprajax.AjaxFilterQueryItem.cls?Action=group", async: false });
        var ret = obj.responseText;
        //2.数据库提取加自定义结果
        var ans = "";
        for (var i = 0; i < category.length;i++)
        {
	        var item = category[i];
	        var str = "|" + item.id + "^" + item.itemName + "^" + item.itemDesc;
	        ans += str
	    }
	    groupIDs = ret + ans;
        var strs = new Array();
        strs = groupIDs.split('|');
        for (var i = 0; i < strs.length; i++) {
	        (function(i){
		        var strsIn = new Array();
	            strsIn = strs[i].split('^');
	            var groupID = strsIn[0];
	            var groupName = strsIn[1];
	            var groupDesc = strsIn[2];

	            $('#fqpg').accordion('add', {
	                selected: false,
	                title: groupDesc,
	                multiple: true,
	                id: groupID
	            });
				if (groupName == "Age")
				{
					$('#' + groupID).html(
						'<div style="padding-left:20px;">从:' + '<input type="text" style="width:70px;" id="ageStart">' +
						'至:' + '<input type="text" style="width:70px;" id="ageEnd"></div>'
					)
				}
				else if (groupName == "DisDate")
				{
					$('#' + groupID).html(
						'<div style="padding-left:20px;margin:10px 0px;">开始日期:' + '<input type="text" id="dateStart"></div>' +
						'<div style="padding-left:20px;margin:10px 0px;">结束日期:' + '<input type="text" id="dateEnd"></div>'
					)
				}
				else{
					$('#' + groupID).html('<ul id="fqpgTree' + groupID + '" class = "easyui-tree"></ul>')
					var dg = $('#fqpgTree'+groupID).tree({
						url:'../DHCEPRSearch.web.eprajax.AjaxFilterQueryItem.cls?Action=tree&FQCategoryID='+groupID,
						checkbox:'true',
						loadFilter:function(data,parent){
							if (groupName == "Gender")
							{
								return GenderInfo
							}else{
								return data;
							}
						}
					});
				}

				$('#' + groupID + " #ageStart").numberbox({
					min: 0,
					precision: 0
				})
				$('#' + groupID + " #ageEnd").numberbox({
					min: 0,
					precision: 0
				})
				$('#' + groupID + " #dateStart").datebox({})
				$('#' + groupID + " #dateEnd").datebox({})
				
		    })(i)
		}
			
            /*
            $('#' + groupID).html('<input id="fqpgFilter' + groupID + '" class="fqpgFilter" name="' + groupID + '" /><table id="fqpgGrid' + groupID + '" class="fqpgGrid"></table>');

            var dg = $('#fqpgGrid' + groupID).datagrid({
                url: '../DHCEPRSearch.web.eprajax.AjaxFilterQueryItem.cls',
                queryParams: {
                    Action: 'detail',
                    GroupID: groupID,
                    FilterWord: '',
                    AlreadyChecked: ''
                },
                method: 'post',
                loadMsg: '数据装载中......',
                singleSelect: false,
                showHeader: true,
                fitColumns: true,
                sortName: 'select',
                remoteSort: false,
                columns: [[
                    { field: 'ck', checkbox: true },
                    { field: 'itemID', title: 'itemID', width: 80, hidden: true },
                    { field: 'itemName', title: '<font color="#6998f0">选择/取消选择 全部项目</font>', width: 80, sortable: true },
                    { field: 'itemAlias', title: 'itemAlias', width: 80, hidden: true },
                    { field: 'group', title: 'group', width: 80, hidden: true },
                    { field: 'groupID', title: 'groupID', width: 80, hidden: true },
                    { field: 'groupDesc', title: 'groupDesc', width: 80, hidden: true },
                    { field: 'select', title: 'select', width: 80, order: 'asc', hidden: true },
                    { field: 'alreadyChecked', title: 'alreadyChecked', width: 80, hidden: true }
                ]],
                rowStyler: function(index, row) {
                    if (row["select"] == "0") {
                        return 'background-color:#F7F7F7;';
                    }
                },
                onLoadSuccess: function(data) {
                    var id = $(this).attr("id");
                    for (var i = 0; i < data.total; i++) {
                        if (data.rows[i]["alreadyChecked"] == "true") {
                            $('#' + id).datagrid("checkRow", i);
                        }
                    }
                }
            });
        }

        $('.fqpgFilter').searchbox({
            width: 290,
            searcher: function(value) {
                var id = $(this).attr("id");
                var idS = id.substring("fqpgFilter".length);
                doFilterFQPG(value, idS);
            }
        });

        function doFilterFQPG(value, name) {
            var queryParams = $('#fqpgGrid' + name).datagrid('options').queryParams;
            queryParams.Action = 'detail';
            queryParams.GroupID = name;
            queryParams.FilterWord = value;


            //获取已选中项目
            var rows = $('#fqpgGrid' + name).datagrid("getChecked");    // 获取所有选中的行
            var selectItemID = "";
            var length = rows.length;
            for (var j = 0; rows && j < length; j++) {
                var row = rows[j];
                var itemID = row["itemID"];
                if (selectItemID == "") {
                    selectItemID = itemID;
                }
                else {
                    selectItemID = selectItemID + "^" + itemID;
                }
            }
            queryParams.AlreadyChecked = selectItemID;
            $('#fqpgGrid' + name).datagrid('options').queryParams = queryParams;
            //重新加载datagrid的数据
            $('#fqpgGrid' + name).datagrid('reload');
        }
		*/
    });

})(jQuery);
