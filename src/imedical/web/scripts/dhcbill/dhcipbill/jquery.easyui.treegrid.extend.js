//hujunbin 14.5.20
//扩展easyui datagrid 级联勾选
//jquery.easyui.treegrid.extend.js
var $ = jQuery;
/**
 * 扩展树表格级联勾选方法：
 * @param {Object} container
 * @param {Object} options
 * @return {TypeName}
 */
jQuery.extend(jQuery.fn.treegrid.methods, {
	/**
	 * 级联选择
	 * @param {Object} target
	 * @param {Object} param
	 *      param包括两个参数:
	 *          id:勾选的节点ID
	 *          deepCascade:是否深度级联
	 * @return {TypeName}
	 */
	cascadeCheck: function(target, param) {
		var opts = jQuery.data(target[0], "treegrid").options;
		if(opts.singleSelect) {
			return;
		}
		var idField = opts.idField; //idField为API里方法的id参数
		var status = false;  //标记当前节点的状态，true:勾选，false:未勾选
		var selectNodes = jQuery(target).treegrid("getSelections"); //获取当前选中项
		for(var i = 0; i < selectNodes.length; i++) {
			if (selectNodes[i][idField] == param.id) {
				status = true;
			}
		}
		
		//级联选择父节点
		selectParent(target, param.id, idField, status);
		selectChildren(target[0], param.id, idField, param.deepCascade, status);
		function selectParent(target, id, idField, status) {
			var parent = jQuery(target).treegrid('getParent', id);
			if(parent) {
				var parentId = parent[idField];
				if(status) {
					jQuery(target).treegrid('select', parentId);
				} else {
					//这里需要判断兄弟节点 add hu
					var hasSelFlag = IsParentHasSelectedChildren(target, parentId, idField, status);
					//alert(hasSelFlag)
					if (!hasSelFlag) {
						jQuery(target).treegrid('unselect', parentId);
					}
				}
				selectParent(target, parentId, idField, status);
			}
		}

		/**
		 * 级联选择子节点
		 * @param {Object} target
		 * @param {Object} id 节点ID
		 * @param {Object} deepCascade 是否深度级联
		 * @param {Object} status 节点状态，true:勾选，false:未勾选
		 * @return {TypeName}
		 */
		function selectChildren(target, id, idField, deepCascade, status) {
			//深度级联时先展开节点
			if (!status && deepCascade) {
				jQuery(target).treegrid('expand', id);
			}
			//根据ID获取下层孩子节点
			var children = jQuery(target).treegrid('getChildren', id);
			for (var i = 0; i < children.length; i++) {
				var childId = children[i][idField];
				if (status) {
					jQuery(target).treegrid('select', childId);
				} else {
					jQuery(target).treegrid('unselect', childId);
				}
				selectChildren(target, childId, idField, deepCascade, status); //递归选择子节点
			}
		}
		
		/**
		 * 级联判断父节点 的子节点是否有被选择的
		 * @param {Object} target
		 * @param {Object} id 节点ID
		 * @return {TypeName}
		 */
		function IsParentHasSelectedChildren(target, id, idField, status) {
			var count = 0;
			var children = target.treegrid('getChildren', id);
			var selectNodes = jQuery(target).treegrid('getSelections'); //获取当前选中项
			var p = target.treegrid('find', id);
			//注意,这里的children是指后代所有子节点,不是指儿子节点,
			//所以要加上children[i]['_parentId']==p[idField]过滤出儿子节点
			for (var i = 0; i < children.length; i++) {
				var childId = children[i][idField];
				for (var j = 0; j < selectNodes.length; j++) {
					if (selectNodes[j][idField] == childId && children[i]['_parentId'] == p[idField])
						count++;
				}
			}
			//注意,click 函数在unselect事件之前运行,//这里需要减去自己
			//alert(count)
			return count  > 0;
		}
	},
	checkOnlySelf: function(target, id) {
		var opts = jQuery.data(target[0], "treegrid").options;
		if(opts.singleSelect) {
			return;
		}
		var idField = opts.idField; //idField为API里方法的id参数
		var status = false;  //标记当前节点的状态，true:勾选，false:未勾选
		var selectNodes = jQuery(target).treegrid("getSelections"); //获取当前选中项
		for(var i = 0; i < selectNodes.length; i++) {
			var selectNode = selectNodes[i];
			jQuery(target).treegrid('unselect', selectNode[idField]);
		}
		jQuery(target).treegrid('select', id);
	}
});
$.extend($.fn.treegrid.defaults, {
		onLoadSuccess : function () {
			var target = $(this);
			var opts = $.data(this, "treegrid").options;
			var panel = $(this).datagrid("getPanel");
			var gridBody = panel.find("div.datagrid-body");
			var idField = opts.idField; //这里的idField其实就是API里方法的id参数
			gridBody.find("div.datagrid-cell-check input[type=checkbox]").unbind(".treegrid").click(function (e) {
				if (opts.singleSelect)
					return; //单选不管
				if (opts.cascadeCheck || opts.deepCascadeCheck) {
					var id = $(this).parent().parent().parent().attr("node-id");
					var status = false;
					if ($(this).attr("checked"))
						status = true;
					//级联选择父节点
					selectParent(target, id, idField, status);
					selectChildren(target, id, idField, opts.deepCascadeCheck, status);
					/**
					 * 级联选择父节点
					 * @param {Object} target
					 * @param {Object} id 节点ID
					 * @param {Object} status 节点状态，true:勾选，false:未勾选
					 * @return {TypeName}
					 */
					function selectParent(target, id, idField, status) {
						var parent = target.treegrid('getParent', id);
						if (parent) {
							var parentId = parent[idField];
							if (status) {
								target.treegrid('select', parentId);
							} else
								target.treegrid('unselect', parentId);
							selectParent(target, parentId, idField, status);
						}
					}
					/**
					 * 级联选择子节点
					 * @param {Object} target
					 * @param {Object} id 节点ID
					 * @param {Object} deepCascade 是否深度级联
					 * @param {Object} status 节点状态，true:勾选，false:未勾选
					 * @return {TypeName}
					 */
					function selectChildren(target, id, idField, deepCascade, status) {
						//深度级联时先展开节点
						if (status && deepCascade)
							target.treegrid('expand', id);
						//根据ID获取下层孩子节点
						var children = target.treegrid('getChildren', id);
						for (var i = 0; i < children.length; i++) {
							var childId = children[i][idField];
							if (status)
								target.treegrid('select', childId);
							else
								target.treegrid('unselect', childId);
							selectChildren(target, childId, idField, deepCascade, status); //递归选择子节点
						}
					}
				}
				e.stopPropagation(); //停止事件传播
			});
		}
	});
