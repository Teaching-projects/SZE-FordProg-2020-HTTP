package jsonxmlparser;

public class ValueHolder {

    String type;

    Integer size;

    public ValueHolder(String type, Integer size) {
        this.type = type;
        this.size = size;
    }

    public ValueHolder(Integer size) {
        this.size = size;
    }

    public ValueHolder(String type) {
        this.type = type;
    }

    public String getType() {
        return type;
    }

    public Integer getSize() {
        return size;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setSize(Integer size) {
        this.size = size;
    }
}
