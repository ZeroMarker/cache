String.format = function() {
    if (arguments.length == 0)
        return null;
    var str = arguments[0];
    for (var i = 1; i < arguments.length; i++) {
        var re = new RegExp('\\{' + (i - 1) + '\\}', 'gm');
        str = str.replace(re, arguments[i]);
    }
    return str;
}

HashTable = function() {
    this.items = new Array();
    this.itemsCount = 0;
    this.add = function(key, value) {
        if (!this.containsKey(key)) {
            this.items[key] = value;
            this.itemsCount++;
        }
    }
    this.get = function(key) {
        if (this.containsKey(key))
            return this.items[key];
        else
            return null;
    }
    this.keys = function() {
        var keys = new Array();
        for (var i in this.items) {
            if (this.items[i] != null)
                keys.push(i);
        }
        return keys;
    }
    this.values = function() {
        var values = new Array();
        for (var i in this.items) {
            if (this.items[i] != null)
                values.push(this.items[i]);
        }
        return values;
    }
    this.remove = function(key) {
        if (this.containsKey(key)) {
            delete this.items[key];
            this.itemsCount--;
        }
    }
    this.containsKey = function(key) {
        return typeof (this.items[key]) != "undefined";

    }
    this.containsValue = function containsValue(value) {
        for (var item in this.items) {
            if (this.items[item] == value)
                return true;
            break;
        }
        return false;
    }
    this.contains = function(keyOrValue) {
        return this.containsKey(keyOrValue) || this.containsValue(keyOrValue);
    }
    this.clear = function() {
        this.items = new Array();
        itemsCount = 0;
    }
    this.size = function() {
        var size = 0;
        for (var i in this.items) {
            if (this.items[i] != null)
                size++;
        }
        return size;
    }
    this.isEmpty = function() {
        return this.size() == 0;
    }
    this.toString = function() {
        var result = '';
        for (var i in this.items) {
            if (this.items[i] != null)
                result += '{' + i + '},{' + this.items[i] + '}\n';
        }
        return result;
    }
}