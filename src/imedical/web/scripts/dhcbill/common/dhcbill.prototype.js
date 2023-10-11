/**
* dhcbill.prototype.js
*/

String.prototype.endsWith = function (str) {
    return (this.match(str + "$") == str);
}

String.prototype.startsWith = function (str) {
    return (this.match("^" + str) == str);
}

/**
 * 数组元素删除
 */
Array.prototype.remove = function(val) {
	var index = val ? this.indexOf(val) : -1;
	if (index > -1) {
		this.splice(index, 1);
	}
}

/**
 * 数组元素去重, 返回新数组
 */
Array.prototype.unique = function() {
	var result = [];
    var hash = {};
    for (var i = 0, elem; (elem = this[i]) != null; i++) {
        if (!hash[elem]) {
            result.push(elem);
            hash[elem] = true;
        }
    }
    return result;
}

/**
* 加法
*/
Number.prototype.add = function(arg) {
	var r1, r2, m;
	try {
		r1 = String(this).split(".")[1].length;
	}catch(e) {
		r1 = 0;
	}
	try {
		r2 = String(arg).split(".")[1].length;
	}catch(e) {
		r2 = 0;
	}
	m = Math.pow(10, Math.max(r1, r2));
	return (this * m + arg * m) / m;
}

/**
* 减法
*/
Number.prototype.sub = function(arg) {
	return this.add(-arg);
}

/**
* 乘法
*/
Number.prototype.mul = function(arg) {
	var m = 0; s1 = String(this), s2 = String(arg);
	try {
		m += s1.split(".")[1].length;
	}catch(e) {
	}
	try {
		m += s2.split(".")[1].length;
	}catch(e) {
	}
	return Number(s1.replace(".","")) * Number(s2.replace(".","")) / Math.pow(10, m);
}

/**
* 除法
*/
Number.prototype.div = function(arg) {
	var t1 = 0; t2 = 0, r1, r2;
	try {
		t1 = String(this).split(".")[1].length;
	}catch(e) {
	}
	try {
		t2 = String(arg).split(".")[1].length;
	}catch(e) {
	}
	r1 = Number(String(this).replace(".",""));
	r2 = Number(String(arg).replace(".",""));
	return (r1 / r2) * Math.pow(10, t2 - t1);
}