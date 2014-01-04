defmodule ExHaml.Doctype do
  
  def doctype_xhtml_transitional do
    """
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    """
  end

  def doctype_xhtml_strict do
    """
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    """
  end

  def doctype_xhtml_frameset do
    """
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
    """
  end

  def doctype_html5 do
    """
    <!DOCTYPE html>
    """
  end

end