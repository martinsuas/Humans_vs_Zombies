import java.util.Comparator;

/**
 * Comparator used to compare tree objects. If used with
 * sort(), will order trees in descending y value to ensure
 * trees in the lower screen get drawn first.
 * @author Martin Suarez
 */
class TreeComparator implements Comparator<Tree> {
      @Override
      public int compare(Tree t1, Tree t2) {
        return (int) (t1.location.y - t2.location.y);
      }
}