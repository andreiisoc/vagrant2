{{ content() }}
{{ form("products/save", "method":"post") }}

<table width="100%">
    <tr>
        <td align="left">{{ link_to("products", "Go Back") }}</td>
        <td align="right">{{ submit_button("Save") }}</td>
    </tr>
</table>

<div align="center">
    <h1>Edit products</h1>
</div>

<table>
    <tr>
        <td align="right">
            <label for="id">Id</label>
        </td>
        <td align="left">
            {{ text_field("id", "type" : "numeric") }}
        </td>
    </tr>
    <tr>
        <td align="right">
            <label for="type_id">Type</label>
        </td>
        <td align="left">
            {{ text_field("type_id", "type" : "numeric") }}
        </td>
    </tr>
    <tr>
        <td align="right">
            <label for="name">Name</label>
        </td>
        <td align="left">
            {{ text_field("name", "size" : 30) }}
        </td>
    </tr>
    <tr>
        <td align="right">
            <label for="price">Price</label>
        </td>
        <td align="left">
            {{ text_field("price", "size" : 30) }}
        </td>
    </tr>
    <tr>
        <td align="right">
            <label for="quantity">Quantity</label>
        </td>
        <td align="left">
            {{ text_field("quantity", "type" : "numeric") }}
        </td>
    </tr>
    <tr>
        <td align="right">
            <label for="status">Status</label>
        </td>
        <td align="left">
                {{ text_field("status") }}
        </td>
    </tr>

    <tr>
        <td>{{ hidden_field("id") }}</td>
        <td>{{ submit_button("Save") }}</td>
    </tr>
</table>

</form>
