(function ($) {
	//datagrid 扩展
	$.extend($.fn.datagrid.methods, {
		editCell: function (jq, param) {
			return jq.each(function () {
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field) {
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		},
		endEditCell: function (jq, param) {
			return jq.each(function () {
				var thisCellEditor = null;
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					if (fields[i] == param.field) {
						thisCellEditor = col.editor;
						col.editor = null;
						break;
					}
				}
				$(this).datagrid('endEdit', param.index);
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					if (fields[i] == param.field) {
						col.editor = thisCellEditor;
						break;
					}
				}
			});
		},
		keyCtr: function (jq) {
			return jq.each(function () {
				var grid = $(this);
				grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
					switch (e.keyCode) {
					case 38: // up
						var selected = grid.datagrid('getSelected');
						if (selected) {
							var index = grid.datagrid('getRowIndex', selected);
							grid.datagrid('selectRow', index - 1);
						} else {
							var rows = grid.datagrid('getRows');
							grid.datagrid('selectRow', rows.length - 1);
						}
						break;
					case 40: // down
						var selected = grid.datagrid('getSelected');
						if (selected) {
							var index = grid.datagrid('getRowIndex', selected);
							grid.datagrid('selectRow', index + 1);
						} else {
							grid.datagrid('selectRow', 0);
						}
						break;
					}
				});
			});
		},
		autoMergeCells: function (jq, fields) {    //自动合并datagrid相同列
			return jq.each(function () {
				var target = $(this);
				if (!fields) {
					fields = target.datagrid("getColumnFields");
				}
				var rows = target.datagrid("getRows");
				var i = 0;
				var j = 0;
				var temp = {};
				for (i; i < rows.length; i++) {
					var row = rows[i];
					j = 0;
					for (j; j < fields.length; j++) {
						var field = fields[j];
						var tf = temp[field];
						if (!tf) {
							tf = temp[field] = {};
							tf[row[field]] = [i];
						} else {
							var tfv = tf[row[field]];
							if (tfv) {
								tfv.push(i);
							} else {
								tfv = tf[row[field]] = [i];
							}
						}
					}
				}
				$.each(temp, function (field, colunm) {
					$.each(colunm, function () {
						var group = this;
						if (group.length > 1) {
							var before;
							var after;
							var megerIndex = group[0];
							for (var i = 0; i < group.length; i++) {
								before = group[i];
								after = group[i + 1];
								if (after && (after - before) == 1) {
									continue;
								}
								var rowspan = before - megerIndex + 1;
								if (rowspan > 1) {
									target.datagrid('mergeCells', {
										index: megerIndex,
										field: field,
										rowspan: rowspan
									});
								}
								if (after && (after - before) != 1) {
									megerIndex = after;
								}
							}
						}
					});
				});
			});
		},
		setFieldValue: function (jq, param) {
			return jq.each(function () {
				var grid = $(this);
				if (param.index === undefined || param.index === '') {
		            param.index = 0;
		        }
				var row = grid.datagrid('getRows')[param.index];
				if (row != null) {
		            var editor = grid.datagrid('getEditor', {index: param.index, field: param.field});
		            if (editor != null) {
		            	grid.datagrid("setEditorValue", param);
		            } else {
			            var view = grid.parent().children('.datagrid-view2');
			            var td = $(view).find('.datagrid-body td[field="' + param.field + '"]')[param.index];
	                    var div = $(td).find('div')[0];
	                    if (div) {
		                    $(div).text(param.value);
		                }
		                row[param.field] = param.value;
		            }
		            grid.datagrid('clearSelections');
		        }
			});
		},
		setEditorValue: function (jq, param) {
			return jq.each(function () {
				var grid = $(this);
				var editor = grid.datagrid('getEditor', {index: param.index, field: param.field});
				if (editor != null) {
					switch (editor.type) {
					case 'text':
			            editor.target.val(param.value);
			            break;
			        case 'combobox':
			            editor.target.combobox('setValue', param.value);
			            break;
			        case 'combotree':
			            editor.target.combotree('setValue', param.value);
			            break;
			        case 'textbox':
			            editor.target.textbox('setValue', param.value);
			            break;
			        case 'validatebox':
			            editor.target.val(param.value);
			            break;
			        case 'numberbox':
			            editor.target.numberbox("setValue", param.value);
			            break;
			        case 'datebox':
			            editor.target.datebox("setValue", param.value);
			            break;
			        case 'datetimebox':
			            editor.target.datebox("setValue", param.value);
			            break;
			        default:
			            editor.html = param.value;
			        }
				}
			});
	    },
	    clientPaging: function (jq) {
		    return jq.each(function() {
			    var pagerFilter = function(data) {
				    if ($.isArray(data)) {   // is array
						data = {
							total: data.length,
							rows: data
						}
					}
					if (!state.allRows) {
						state.allRows = data.rows;
					}
					if (!opts.remoteSort && opts.sortName) {
						var names = opts.sortName.split(',');
						var orders = opts.sortOrder.split(',');
						state.allRows.sort(function(r1, r2) {
							var r = 0;
							for(var i = 0; i < names.length; i++) {
								var sn = names[i];
								var so = orders[i];
								var col = $(target).datagrid('getColumnOption', sn);
								var sortFunc = col.sorter || function(a,b){
									return (a == b) ? 0 : ((a > b) ? 1 :-1);
								};
								r = sortFunc(r1[sn], r2[sn]) * ((so=='asc') ? 1 : -1);
								if (r != 0) {
									return r;
								}
							}
							return r;
						});
					}
					if (opts.pagination) {
						if (state.allRows.length > 0) {
							var start = (opts.pageNumber == 0 ? 1 : opts.pageNumber - 1) * parseInt(opts.pageSize);
							if ((start + 1) > state.allRows.length) {
								//取现有行数最近的整页起始值
								start = Math.floor((state.allRows.length - 1) / opts.pageSize) * opts.pageSize;
								opts.pageNumber = (start / opts.pageSize) + 1;
							}
							//解决页码显示不正确的问题
							$.extend($.data(pager[0], "pagination").options,{pageNumber: opts.pageNumber});
							
							var end = start + parseInt(opts.pageSize);
							data.rows = state.allRows.slice(start, end);
						}
					}
					return data;
				};
				
				var grid = $(this);
                var state = grid.data('datagrid');
                var opts = state.options;
                opts.loadFilter = pagerFilter;
                var onBeforeLoad = opts.onBeforeLoad;
                opts.onBeforeLoad = function(param) {
                    state.allRows = null;
                    return onBeforeLoad.call(this, param);
                }
                var pager = grid.datagrid('getPager');
				pager.pagination({
					showRefresh: false,
					onSelectPage: function(pageNum, pageSize){
						opts.pageNumber = pageNum;
						opts.pageSize = pageSize;
						pager.pagination('refresh',{
							pageNumber: pageNum,
							pageSize: pageSize
						});
						grid.datagrid('loadData',state.allRows);
					}
				});
                $(this).datagrid('loadData', state.data);
                if (opts.url){
                	$(this).datagrid('reload');
                }
			});
		}
	});
	
	/**
	 * 1）扩展jquery easyui tree的节点检索方法。使用方法如下：
	 * $("#treeId").tree("search", searchText);
	 * 其中，treeId为easyui tree的根UL元素的ID，searchText为检索的文本。
	 * 如果searchText为空或""，将恢复展示所有节点为正常状态
	 */
	$.extend($.fn.tree.methods, {
        /**
         * 扩展easyui tree的搜索方法
         * @param tree easyui tree的根DOM节点(UL节点)的jQuery对象
         * @param searchText 检索的文本
         * @param this-context easyui tree的tree对象
         */
        search: function (jq, searchText) {
            var tree = $(this);
            //获取所有的树节点
            var nodeList = getAllNodes(jq, tree);
            //如果没有搜索条件，则展示所有树节点
            searchText = $.trim(searchText);
            if (searchText == "") {
                for (var i = 0; i < nodeList.length; i++) {
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");
                    $(nodeList[i].target).show();
                }
                //展开已选择的节点(如果之前选择了)
                var selectedNode = tree.tree("getSelected");
                if (selectedNode) {
                    tree.tree("expandTo", selectedNode.target);
                }
                return;
            }
            //搜索匹配的节点并高亮显示
            var matchedNodeList = [];
            if (nodeList && nodeList.length > 0) {
                var node = null;
                for (var i = 0; i < nodeList.length; i++) {
                    node = nodeList[i];
                    if (isMatch(searchText, node.text)) {
                        matchedNodeList.push(node);
                    }
                }
                //隐藏所有节点
                for (var i = 0; i < nodeList.length; i++) {
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");
                    $(nodeList[i].target).hide();
                }
                //折叠所有节点
                tree.tree("collapseAll");
                //展示所有匹配的节点以及父节点
                for (var i = 0; i < matchedNodeList.length; i++) {
                    showMatchedNode(jq, tree, matchedNodeList[i]);
                }
            }
        },
        /**
         * 展示节点的子节点（子节点有可能在搜索的过程中被隐藏了）
         * @param node easyui tree节点
         */
        showChildren: function (jq, node) {
            var tree = $(this);
            //展示子节点
            if (!tree.tree("isLeaf", node.target)) {
                var children = tree.tree("getChildren", node.target);
                if (children && children.length > 0) {
                    for (var i = 0; i < children.length; i++) {
                        if ($(children[i].target).is(":hidden")) {
                            $(children[i].target).show();
                        }
                    }
                }
            }
        },
        /**
         * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动）
         * @param param {
         *  treeContainer: easyui tree的容器（即存在滚动条的树容器）。如果为null，则取easyui tree的根UL节点的父节点。
         *  targetNode: 将要滚动到的easyui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动
         * }
         */
        scrollTo: function (jq, param) {
            var tree = $(this);
            //如果node为空，则获取当前选中的node
            var targetNode = param && param.targetNode ? param.targetNode : tree.tree("getSelected");
            if (targetNode != null) {
                //判断节点是否在可视区域
                var root = tree.tree("getRoot");
                var $targetNode = $(targetNode.target);
                var container = param && param.treeContainer ? param.treeContainer : jq.parent();
                var containerH = container.height();
                var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;
                if (nodeOffsetHeight > (containerH - 30)) {
                    var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;
                    container.scrollTop(scrollHeight);
                }
            }
        }
    });
    /**
     * 展示搜索匹配的节点
     */
    function showMatchedNode(jq, tree, node) {
        //展示所有父节点
        $(node.target).show();
        $(".tree-title", node.target).addClass("tree-node-targeted");
        var pNode = node;
        while ((pNode = tree.tree("getParent", pNode.target))) {
            $(pNode.target).show();
        }
        //展开到该节点
        tree.tree("expandTo", node.target);
        //如果是非叶子节点，需折叠该节点的所有子节点
        if (!tree.tree("isLeaf", node.target)) {
            tree.tree("collapse", node.target);
        }
    }
    /**
     * 判断searchText是否与targetText匹配
     * @param searchText 检索的文本
     * @param targetText 目标文本
     * @return true-检索的文本与目标文本匹配；否则为false.
     */
    function isMatch(searchText, targetText) {
        return $.trim(targetText) != "" && targetText.indexOf(searchText) != -1;
    }
    /**
     * 获取easyui tree的所有node节点
     */
    function getAllNodes(jq, tree) {
        var allNodeList = jq.data("allNodeList");
        if (!allNodeList) {
            var roots = tree.tree("getRoots");
            allNodeList = getChildNodeList(jq, tree, roots);
            jq.data("allNodeList", allNodeList);
        }
        return allNodeList;
    }
    /**
     * 定义获取easyui tree的子节点的递归算法
     */
    function getChildNodeList(jq, tree, nodes) {
        var childNodeList = [];
        if (nodes && nodes.length > 0) {
            var node = null;
            for (var i = 0; i < nodes.length; i++) {
                node = nodes[i];
                childNodeList.push(node);
                if (!tree.tree("isLeaf", node.target)) {
                    var children = tree.tree("getChildren", node.target);
                    childNodeList = childNodeList.concat(getChildNodeList(jq, tree, children));
                }
            }
        }
        return childNodeList;
    }
	
	//validatebox扩展
	$.extend($.fn.validatebox.defaults.rules, {
		postcode: {
			validator: function(value) {
				return /^[0-9]{6}$/.test(value);
			},
			message: $g('请输入有效的邮政编码')
		},
		telephone: {
			validator: function(value) {
				return /^((0\d{2,3})(|-))?(\d{7,8})$/.test(value);
			},
			message: $g('请输入有效的电话号码')
		},
		mobilephone: {
			validator: function(value) {
				return /^1[3|4|5|6|7|8|9][0-9]{9}$/.test(value);
			},
			message: $g('请输入有效的手机号')
		},
		telOrMobile: {
			validator: function(value) {
				return ((/^((0\d{2,3})(|-))?(\d{7,8})$/.test(value)) || (/^1[3|4|5|6|7|8|9][0-9]{9}$/.test(value)));
			},
			message: $g('请输入有效的电话号码或手机号')
		},
		personName: {
			validator: function(value) {
				return !(/[`:_~!@#$%^&*() \- \+ =<>?"{}|, \/ ;' \\ [ \] ~！@#￥%……&*（）—— \+ ={}|《》？：“”【】、；‘’，。、]|[0-9]/g.test(value));
			},
			message: $g('请输入正确的人名')
		}
	});
	
	//linkbutton扩展
	$.extend($.fn.linkbutton.methods, {
	    toggleAble: function (jq) {
	        return jq.each(function () {
	            var $this = $(this);
	            $this.linkbutton("disable");
	            var hander = setInterval(function () {
	                    clearInterval(hander);
	                    $this.linkbutton("enable");
	                }, 1000);
	        });
	    }
	});
})(jQuery);