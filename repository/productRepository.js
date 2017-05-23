(function() {

    'use strict';

    var q = require('q');

    module.exports = function(dbPool) {

        function queryFromPool(queryCallback) {
            var deferred = q.defer();

            dbPool.getConnection(function(connectionError, connection){

                if(connectionError) {

                    deferred.reject(connectionError);
                } else {
                    queryCallback(deferred, connection);
                    connection.release();
                }
            });

            return deferred.promise;
        }

        return {
            getAll: function(searchParam) {

                var query = 'SELECT * FROM product ORDER BY name';
                var queryParams = [];

                if(searchParam) {
                    query = 'SELECT * FROM product WHERE name LIKE ?';
                    queryParams = ['%' + searchParam + '%'];
                }

                return queryFromPool(function(deferred, connection) {

                    connection.query(query, queryParams, function(queryError, rows) {

                        if(queryError)
                            deferred.reject(queryError);
                        else
                            deferred.resolve(rows);
                    });
                });
            },
            add: function(newProduct) {

                return queryFromPool(function(deferred, connection) {

                    connection.query('INSERT INTO product (name, description) VALUES (?, ?)',
                        [newProduct.name, newProduct.description || null], function(queryError, resultInfo) {

                            if(queryError)
                                deferred.reject(queryError);
                            else
                                deferred.resolve(resultInfo.insertId);
                        });
                });
            },
            getById: function(productId) {

                return queryFromPool(function(deferred, connection) {

                    connection.query('SELECT * FROM product WHERE id = ?', [productId], function(queryError, row) {

                        if(queryError)
                            deferred.reject(queryError);
                        else
                            deferred.resolve(row);
                    });
                });
            },
            update: function(productId, updatedProduct) {

                return queryFromPool(function(deferred, connection) {

                    connection.query('UPDATE product SET name = ?, description = ? WHERE id = ?',
                        [updatedProduct.name, updatedProduct.description || null ,productId], function(queryError) {

                            if(queryError)
                                deferred.reject(queryError);
                            else
                                deferred.resolve();
                        });
                });
            },
            removeById: function(productId) {

                return queryFromPool(function(deferred, connection) {

                    connection.query('DELETE FROM product WHERE id = ?', [productId], function(queryError) {

                        if(queryError)
                            deferred.reject(queryError);
                        else
                            deferred.resolve();
                    });
                });
            }
        };
    };
})();
