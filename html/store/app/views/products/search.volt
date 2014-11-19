
{{ content() }}

<table width="100%">
    <tr>
        <td align="left">
            {{ link_to("products/index", "Go Back") }}
        </td>
        <td align="right">
            {{ link_to("products/new", "Create ") }}
        </td>
    </tr>
</table>

<table class="browse" align="center">
    <thead>
        <tr>
            <th>Id</th>
            <th>Type</th>
            <th>Name</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Status</th>
         </tr>
    </thead>
    <tbody>
    {% if page.items is defined %}
    {% for product in page.items %}
        <tr>
            <td>{{ product.id }}</td>
            <td>{{ product.type_id }}</td>
            <td>{{ product.name }}</td>
            <td>{{ product.price }}</td>
            <td>{{ product.quantity }}</td>
            <td>{{ product.status }}</td>
            <td>{{ link_to("products/edit/"~product.id, "Edit") }}</td>
            <td>{{ link_to("products/delete/"~product.id, "Delete") }}</td>
        </tr>
    {% endfor %}
    {% endif %}
    </tbody>
    <tbody>
        <tr>
            <td colspan="2" align="right">
                <table align="center">
                    <tr>
                        <td>{{ link_to("products/search", "First") }}</td>
                        <td>{{ link_to("products/search?page="~page.before, "Previous") }}</td>
                        <td>{{ link_to("products/search?page="~page.next, "Next") }}</td>
                        <td>{{ link_to("products/search?page="~page.last, "Last") }}</td>
                        <td>{{ page.current~"/"~page.total_pages }}</td>
                    </tr>
                </table>
            </td>
        </tr>
    </tbody>
</table>
